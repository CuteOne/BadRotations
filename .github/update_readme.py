from sys import argv, stderr
from pathlib import Path, PosixPath
from typing import DefaultDict, Dict, List
from git import Repo
from collections import defaultdict
from pytablewriter import MarkdownTableWriter, style
from datetime import datetime
import re

REGEX = {
    "Name": re.compile(r"local rotationName\s*=\s*\"(.+)\""),
    "Author": re.compile(r"-- Author =(.+)"),
    "Patch": re.compile(r"-- Patch =(.+)"),
    "Coverage": re.compile(r"-- Coverage =(.+)"),
    "Status": re.compile(r"-- Status =(.+)"),
    "Readiness": re.compile(r"-- Readiness =(.+)")
    }
ORDERED_CLASSES = ("Death Knight", "Demon Hunter", "Druid",
                   "Hunter", "Mage", "Monk", "Paladin",
                   "Priest", "Rogue", "Shaman", "Warlock", "Warrior")
ICON = {
    "Raid": ":white_check_mark:",
    "NoRaid": ":x:",
    "Basic": ":heavy_check_mark:",
    "Development": ":interrobang:",
    "Untested": ":interrobang:"
}
CJUST = style.Style(align="center")
RJUST = style.Style(align="right")

def fatal(exit_code: int, err: str) -> None:
    print(err, file=stderr)
    exit(exit_code)

def error(err: str) -> None:
    print(err, file=stderr)

def filter_filepath(path: PosixPath) -> bool:
    return (not path.name == "sample rotation.lua") and \
        (not path.name == "Blank.lua") and \
        (not path.match("Old/*.lua")) and \
        (not path.match("Old/**/*.lua")) and \
        (not path.match("Initial/*.lua")) and \
        (not path.match("Support/*.lua")) and \
        (not path.match("_*.lua"))

def build_rotation_entry(repo: Repo, repo_dir: PosixPath, rotation: PosixPath) -> Dict[str, str]:
    script = rotation.read_text()
    result = {}

    for field, regex in REGEX.items():
        try:
            result[field] = regex.search(script).group(1).lstrip()
            if field == "Readiness":
                try:
                    result[field] = ICON[result[field]]
                except KeyError:
                    result[field] = ":interrobang:"
        except AttributeError:
            error(3, f"Couldn't find {field} in {rotation.name}.")
        
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
            [x["Name"], x["Author"], x["Patch"], x["Coverage"], x["Status"], x["Readiness"], date]
        )
    return table

def write_class_table(wow_class: str, wow_specs: DefaultDict) -> str:
    result = f"\n### {wow_class}\n\n"
    for spec, info_list in wow_specs.items():
        result += f"- {spec}\n\n"
        writer = MarkdownTableWriter(
            headers=("rotation", "author", "patch", "coverage", "status", "readiness", "last updated"),
            type_hints=["str"] * 7,
            column_styles=(None, None, CJUST, CJUST, CJUST, CJUST, RJUST),
            value_matrix=build_spec_table(info_list)
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
            entries[wow_class][wow_spec].append(build_rotation_entry(repo, repo_dir, rotation))
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
