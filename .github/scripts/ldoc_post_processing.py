import os
import re
from bs4 import BeautifulSoup

# Directory containing the generated LDoc HTML files
DOCS_DIR = './docs/'

# Iterate over all HTML files in the directory
for filename in os.listdir(DOCS_DIR):
    if filename.endswith('.html'):
        filepath = os.path.join(DOCS_DIR, filename)
        print(f"Processing {filepath}...")  # Debug print

        with open(filepath, 'r', encoding='utf-8') as file:
            soup = BeautifulSoup(file, 'html.parser')

            # Find all h2 tags (module names)
            for h2_tag in soup.find_all('h2'):
                module_name = h2_tag.text.strip()
                print(f"Found module: {module_name}")  # Debug print

                # For each subsequent dt tag (function or type name), prepend the module name if not already present
                for dt_tag in h2_tag.find_all_next('dt'):
                    if not dt_tag.text.startswith(module_name + '.'):
                        dt_tag.string = module_name + '.' + dt_tag.text
                        print(f"Updated to: {dt_tag.string}")  # Debug print

        # Write the modified HTML back to the file
        with open(filepath, 'w', encoding='utf-8') as file:
            file.write(str(soup))

print("Processing complete.")
