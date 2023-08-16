import os
import re

# Get the directory where the script is located
script_dir = os.path.dirname(os.path.abspath(__file__))

# Directory containing the API files
API_DIR = os.path.join(script_dir, "..", "System", "API")

# Placeholder for documentation content
docs = []

# Process each file in the directory
for filename in os.listdir(API_DIR):
    filepath = os.path.join(API_DIR, filename)

    with open(filepath, "r") as f:
        lines = f.readlines()

    # Iterate over the lines and look for the @xFunction tag
    i = 0
    while i < len(lines):
        line = lines[i]
        if "@xFunction" in line:
            func_name = re.search(r"@xfunction (.+)", line).group(1)
            doc_block = [f"### {func_name}\n"]
            i += 1
            while i < len(lines) and not lines[i].strip().startswith("cast."):
                if "@xdescription" in lines[i]:
                    description = re.search(r"@xdescription (.+)", lines[i]).group(1)
                    doc_block.append(f"\n{description}\n")
                elif "@xtparam" in lines[i]:
                    tparam = re.search(r"@xtparam (.+)", lines[i]).group(1)
                    doc_block.append(f"- Parameter: {tparam}")
                elif "@xreturn" in lines[i]:
                    return_val = re.search(r"@xreturn (.+)", lines[i]).group(1)
                    doc_block.append(f"- Returns: {return_val}")
                i += 1
            docs.append("\n".join(doc_block) + "\n")
        else:
            i += 1

# Sort the documentation blocks alphabetically by function name (if desired)
docs = sorted(docs)

# Write the documentation to a Markdown file
with open(os.path.join(script_dir, "..", "DOCS.md"), "w") as f:
    f.write("\n".join(docs))
