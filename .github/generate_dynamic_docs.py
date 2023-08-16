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

    # Iterate over the lines and look for the @dynamicFunction tag
    i = 0
    while i < len(lines):
        line = lines[i]
        if "@dynamicFunction" in line:
            func_name = re.search(r"@dynamicFunction (.+)", line).group(1)
            doc_block = [f"### {func_name}\n"]
            i += 1
            while i < len(lines) and not lines[i].strip().startswith("cast."):
                if "@description" in lines[i]:
                    description = re.search(r"@description (.+)", lines[i]).group(1)
                    doc_block.append(f"\n{description}\n")
                elif "@tparam" in lines[i]:
                    tparam = re.search(r"@tparam (.+)", lines[i]).group(1)
                    doc_block.append(f"- Parameter: {tparam}")
                elif "@return" in lines[i]:
                    return_val = re.search(r"@return (.+)", lines[i]).group(1)
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