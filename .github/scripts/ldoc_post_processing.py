import os
from bs4 import BeautifulSoup

# Define the directory where the LDoc-generated HTML files are located
DOCS_DIR = './docs'

# Recursive function to process each HTML file in the directory and its subdirectories
def process_directory(directory):
    for filename in os.listdir(directory):
        filepath = os.path.join(directory, filename)
        if os.path.isdir(filepath):
            process_directory(filepath)
        elif filename.endswith('.html'):
            print(f"Processing {filepath}...")

            with open(filepath, 'r', encoding='utf-8') as file:
                soup = BeautifulSoup(file, 'html.parser')

                # Extract the module name from the <code> tag inside the h1 tag
                h1_tag = soup.find('h1')
                code_tag = h1_tag.find('code') if h1_tag else None
                if code_tag and "br.player." in code_tag.text:
                    module_name = code_tag.text.split('.')[-1]
                    print(f"Extracted module name: {module_name}")

                    # [Rest of the script remains unchanged]

                    # Save the changes back to the file
                    with open(filepath, 'w', encoding='utf-8') as file:
                        file.write(str(soup))
                else:
                    print(f"No module name found in {filepath}")

            print(f"Processed {filepath}.")

# Start the processing from the root docs directory
process_directory(DOCS_DIR)
print("Processing complete.")
