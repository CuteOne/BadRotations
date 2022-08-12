from sys import argv, stderr
from pathlib import Path, PosixPath
from typing import DefaultDict, Dict, List
from git import Repo
from collections import defaultdict
from pytablewriter import MarkdownTableWriter, style
from datetime import datetime
import re


FIELDS = {
    "Rotation": {
        "regex": re.compile(r"local rotationName\s*=\s*\"(.+)\""),
        "default": lambda _, file: file.rstrip(".lua"),
    },
    "Author": {
        "regex": re.compile(r"-- Author =(.+)"),
        "default": lambda repo, file: get_first_committer(repo, file),
    },
    "Patch": {"regex": re.compile(r"-- Patch =(.+)"), "default": "Unknown"},
    "Coverage": {"regex": re.compile(r"-- Coverage =(.+)"), "default": "Unknown"},
    "Status": {"regex": re.compile(r"-- Status =(.+)"), "default": "Unknown"},
    "Readiness": {"regex": re.compile(r"-- Readiness =(.+)"), "default": "Untested"},
}
IN_FILTER = re.compile(r"[\[\]<>]+", re.UNICODE)
ORDERED_CLASSES = (
    "Death Knight",
    "Demon Hunter",
    "Druid",
    "Hunter",
    "Mage",
    "Monk",
    "Paladin",
    "Priest",
    "Rogue",
    "Shaman",
    "Warlock",
    "Warrior",
)
ICON = {
    "Raid": ":white_check_mark:",
    "NoRaid": ":x:",
    "Basic": ":heavy_check_mark:",
    "Development": ":interrobang:",
    "Untested": ":interrobang:",
}
CJUST = style.Style(align="center")
RJUST = style.Style(align="right")


def fatal(exit_code: int, err: str) -> None:
    print(err, file=stderr)
    exit(exit_code)


def error(err: str) -> None:
    print(err, file=stderr)


def filter_filepath(path: PosixPath) -> bool:
    return (
        (not path.name == "sample rotation.lua")
        and (not path.name == "Blank.lua")
        and (not path.match("Old/*.lua"))
        and (not path.match("Old/**/*.lua"))
        and (not path.match("Initial/*.lua"))
        and (not path.match("Support/*.lua"))
        and (not path.match("_*.lua"))
    )


def filter_input(in_str: str, max_len: int) -> str:
    filtered_str = IN_FILTER.sub("", in_str)
    return filtered_str[: min(max_len, len(filtered_str))]


def get_first_committer(repo: Repo, filepath: PosixPath) -> str:
    # Can't use max-parents=0 trick because many "initial" commits were merge requests
    return list(repo.iter_commits(paths=filepath))[-1].author.name


def build_rotation_entry(
    repo: Repo, repo_dir: PosixPath, rotation: PosixPath
) -> Dict[str, str]:
    script = rotation.read_text()
    result = {}

    for field, action in FIELDS.items():
        if (search := action["regex"].search(script)) == None:
            if callable(action["default"]):
                result[field] = action["default"](repo, rotation)
            else:
                result[field] = action["default"]
        else:
            result[field] = search.group(1).lstrip()

        if field == "Readiness":
            try:
                result[field] = ICON[result[field]]
            except KeyError:
                result[field] = ":interrobang:"

    relative_path = rotation.relative_to(repo_dir)
    result["Updated"] = get_last_commit_date_by_path(relative_path, repo)

    return result


def get_last_commit_date_by_path(filepath: PosixPath, repo: Repo) -> int:
    commits_iter = repo.iter_commits(paths=filepath)
    while (commit := next(commits_iter, None)) is not None:
        if not commit.message.startswith("--"):
            return commit.committed_date
    fatal(4, f"Couldn't find git blob for {filepath}")


def build_spec_table(info_list: List[Dict[str, str]]) -> List[str]:
    table = []
    info_list.sort(key=lambda x: x["Updated"], reverse=True)
    for x in info_list:
        date = datetime.fromtimestamp(x["Updated"]).strftime("%m/%d/%Y")
        table.append(
            [
                filter_input(x["Rotation"], max_len=32),
                filter_input(x["Author"], max_len=32),
                filter_input(x["Patch"], max_len=16),
                filter_input(x["Coverage"], max_len=32),
                filter_input(x["Status"], max_len=32),
                filter_input(x["Readiness"], max_len=32),
                date,
            ]
        )
    return table


def write_class_table(wow_class: str, wow_specs: DefaultDict) -> str:
    result = f"\n### {wow_class}\n\n"
    for spec in sorted(wow_specs.keys()):
        result += f"- {spec}\n\n"
        writer = MarkdownTableWriter(
            headers=(
                "rotation",
                "author",
                "patch",
                "coverage",
                "status",
                "readiness",
                "last updated",
            ),
            type_hints=["str", "str", "str", "str", "str", "str", "str"],
            column_styles=(None, None, CJUST, CJUST, CJUST, CJUST, RJUST),
            value_matrix=build_spec_table(wow_specs[spec]),
        )
        result += f"{writer.dumps()}\n"
    return result


def write_readme(readme: PosixPath, insert: str) -> None:
    contents = readme.read_text().split("\n")
    offset = contents.index("<!-- rotations -->") + 1
    readme.write_text("\n".join(contents[:offset]) + insert)


def main(repo_dir: str) -> None:
    rotations_dir = repo_dir / "Rotations"
    if not rotations_dir.is_dir():
        fatal(3, f"Rotations directory not found at {rotations_dir}.")

    repo = Repo(repo_dir)
    rotations = [x for x in rotations_dir.rglob("*.lua") if filter_filepath(x)]

    entries = defaultdict(lambda: defaultdict(list))
    insert = ""

    for rotation in rotations:
        wow_class, wow_spec = rotation.relative_to(rotations_dir).parts[:2]
        try:
            entries[wow_class][wow_spec].append(
                build_rotation_entry(repo, repo_dir, rotation)
            )
        except:
            # Continue if a rotation fails to parse
            pass

    for wow_class in ORDERED_CLASSES:
        insert += write_class_table(wow_class, entries[wow_class])

    write_readme(repo_dir / "README.md", insert)


if __name__ == "__main__":
    if len(argv) != 2:
        fatal(1, f"Incorrect number of arguments. Format: {argv[0]} <repo path>")
    repo_dir = Path(argv[1])
    if not repo_dir.is_dir():
        fatal(2, f"Rotations directory not found at {repo_dir}.")
    main(repo_dir)
