from sys import argv, stderr
from pathlib import Path, PosixPath
from typing import Dict, List
from git import Repo
from collections import defaultdict
from datetime import datetime
from html import escape
from itertools import groupby
import re


# Rotation metadata comes from the registerRotation({ ... }) table in each rotation file.
REGISTER_BLOCK = re.compile(r"(?<![\w.:])registerRotation\s*\(\s*\{(.*?)\}\s*\)", re.S)


def register_field(name: str) -> re.Pattern:
    return re.compile(r"\b" + name + r"\s*=\s*\"([^\"]*)\"")


FIELDS = {
    "Rotation": {
        # name = "Literal" in the table, or the profile's local rotationName
        "regex": [register_field("name"), re.compile(r"local rotationName\s*=\s*\"(.+?)\"")],
        "default": lambda _, file: file.stem,
    },
    "Author": {
        "regex": [register_field("author")],
        "default": lambda repo, file: get_first_committer(repo, file),
    },
    "Flavour": {"regex": [register_field("expansion")], "default": "Unknown"},
}
# Git names that belong to one author
AUTHOR_ALIASES = {"ph34rt3hcute1": "CuteOne", "Ashley (CuteOne)": "CuteOne"}
# Flavours in README order, with the heading each gets
FLAVOURS = {
    "Retail": "Retail",
    "MOP": "Mists of Pandaria Classic",
    "TBC": "Burning Crusade Classic",
    "Classic": "Classic Era",
    "Forever": "World of Warcraft Forever",
}
# A profile with specID = 0 is switched off and never loads
DISABLED = re.compile(r"\bspecID\s*=\s*0\b")
ORDERED_CLASSES = (
    "Death Knight",
    "Demon Hunter",
    "Druid",
    "Evoker",
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
IN_FILTER = re.compile(r"[\[\]<>]+", re.UNICODE)
START = "<!-- rotations -->"
END = "<!-- /rotations -->"


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
    block = REGISTER_BLOCK.search(script)
    register = block.group(1) if block else ""
    result = {}

    for field, action in FIELDS.items():
        search = None
        for i, regex in enumerate(action["regex"]):
            # Registration fields are read from the table; fallbacks search the whole file
            search = regex.search(register if i == 0 else script)
            if search:
                break
        if search is None:
            if callable(action["default"]):
                result[field] = action["default"](repo, rotation)
            else:
                result[field] = action["default"]
        else:
            result[field] = search.group(1).strip()

    result["Author"] = AUTHOR_ALIASES.get(result["Author"], result["Author"])
    result["Disabled"] = bool(DISABLED.search(register))
    relative_path = rotation.relative_to(repo_dir)
    result["Updated"] = get_last_commit_date_by_path(relative_path, repo)

    return result


def get_last_commit_date_by_path(filepath: PosixPath, repo: Repo) -> int:
    commits_iter = repo.iter_commits(paths=filepath)
    while (commit := next(commits_iter, None)) is not None:
        if not commit.message.startswith("--"):
            return commit.committed_date
    fatal(4, f"Couldn't find git blob for {filepath}")


def spec_label(wow_class: str, wow_spec: str) -> str:
    # Clients without specializations keep a class's profiles in Rotations/<Class>/<Class>/
    if wow_spec == wow_class:
        return "All"
    if wow_spec == "Initial":
        return "Starter"
    return wow_spec


def spec_order(spec: str) -> tuple:
    # Specs alphabetically, the starter profile after them
    return (spec == "Starter", spec)


def cell(tag: str, text: str, rows: int = 1) -> str:
    span = f' rowspan="{rows}"' if rows > 1 else ""
    return f"<{tag}{span}>{escape(text)}</{tag}>"


def write_flavour_table(flavour: str, entries: List[Dict[str, str]]) -> str:
    # HTML, not Markdown, so a class and a spec can each span their rows
    class_order = {name: i for i, name in enumerate(ORDERED_CLASSES)}
    entries.sort(
        key=lambda x: (class_order.get(x["Class"], len(class_order)), spec_order(x["Spec"]), -x["Updated"])
    )
    # On clients without specializations every profile is "All": leave the column out
    show_spec = any(x["Spec"] != "All" for x in entries)
    headers = ["Class"] + (["Spec"] if show_spec else []) + ["Rotation", "Author", "Last updated"]
    lines = ["<table>", "<tr>" + "".join(cell("th", h) for h in headers) + "</tr>"]
    for wow_class, class_rows in groupby(entries, key=lambda x: x["Class"]):
        class_rows = list(class_rows)
        first_in_class = True
        for spec, spec_rows in groupby(class_rows, key=lambda x: x["Spec"]):
            spec_rows = list(spec_rows)
            for i, x in enumerate(spec_rows):
                row = ""
                if first_in_class:
                    row += cell("th", wow_class, len(class_rows))
                    first_in_class = False
                if show_spec and i == 0:
                    row += cell("td", spec, len(spec_rows))
                row += cell("td", filter_input(x["Rotation"], max_len=32))
                row += cell("td", filter_input(x["Author"], max_len=32))
                row += cell("td", datetime.fromtimestamp(x["Updated"]).strftime("%Y-%m-%d"))
                lines.append(f"<tr>{row}</tr>")
    lines.append("</table>")
    return f"\n### {FLAVOURS.get(flavour, flavour)}\n\n" + "\n".join(lines) + "\n"


def write_readme(readme: PosixPath, insert: str) -> None:
    contents = readme.read_text()
    start = contents.index(START) + len(START)
    end = contents.index(END, start)
    readme.write_text(contents[:start] + "\n" + insert + "\n" + contents[end:])


def main(repo_dir: str) -> None:
    rotations_dir = repo_dir / "Rotations"
    if not rotations_dir.is_dir():
        fatal(3, f"Rotations directory not found at {rotations_dir}.")

    repo = Repo(repo_dir)
    rotations = [x for x in rotations_dir.rglob("*.lua") if filter_filepath(x)]

    entries = defaultdict(list)

    for rotation in rotations:
        wow_class, wow_spec = rotation.relative_to(rotations_dir).parts[:2]
        try:
            entry = build_rotation_entry(repo, repo_dir, rotation)
        except Exception as err:
            error(f"Skipped {rotation.relative_to(rotations_dir)}: {err}")
            continue
        if entry["Disabled"]:
            continue
        entry["Class"] = wow_class
        entry["Spec"] = spec_label(wow_class, wow_spec)
        entries[entry["Flavour"]].append(entry)

    # Known flavours in their order, then anything unexpected so it is not lost
    order = [f for f in FLAVOURS if f in entries] + sorted(set(entries) - set(FLAVOURS))
    insert = "".join(write_flavour_table(f, entries[f]) for f in order)

    write_readme(repo_dir / "README.md", insert)


if __name__ == "__main__":
    if len(argv) != 2:
        fatal(1, f"Incorrect number of arguments. Format: {argv[0]} <repo path>")
    repo_dir = Path(argv[1])
    if not repo_dir.is_dir():
        fatal(2, f"Rotations directory not found at {repo_dir}.")
    main(repo_dir)
