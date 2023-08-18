import os
import re

# Directory containing the generated LDoc HTML files
doc_dir = './docs'

def extract_modules_from_file(filepath):
    """Extract module names from an HTML file."""
    with open(filepath, 'r', encoding='utf-8') as file:
        content = file.read()
        # Regular expression to match module names
        module_pattern = r'<h2>(\w+)</h2>'
        return re.findall(module_pattern, content)

def process_file(filepath, modules):
    """Process an HTML file to append module names where needed."""
    with open(filepath, 'r', encoding='utf-8') as file:
        content = file.read()

        # For each module, find occurrences where the module prefix is missing and add it
        for module in modules:
            content = re.sub(r'(?<!\b' + module + r'\.)\b' + module + r'\b', module + '.' + module, content)

        # Save the modified content back to the file
        with open(filepath, 'w', encoding='utf-8') as file:
            file.write(content)

# Traverse the documentation directory and process each HTML file
for root, dirs, files in os.walk(doc_dir):
    for file in files:
        if file.endswith('.html'):
            filepath = os.path.join(root, file)
            modules = extract_modules_from_file(filepath)
            process_file(filepath, modules)

print("Post-processing completed!")
