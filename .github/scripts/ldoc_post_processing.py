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

                # Extract the module name from the h1 tag
                h1_tag = soup.find('h1')
                if h1_tag and "Module" in h1_tag.text:
                    module_name = h1_tag.text.split()[-1].split('.')[-1]
                    print(f"Extracted module name: {module_name}")

                    # Find all function names and prepend the module name if not already present
                    for dt in soup.find_all('dt'):
                        function_name = dt.string
                        if function_name and not function_name.startswith(module_name + '.'):
                            print(f"Updating function name: {function_name} to {module_name}.{function_name}")
                            dt.string = module_name + '.' + function_name

                    # Save the changes back to the file
                    with open(filepath, 'w', encoding='utf-8') as file:
                        file.write(str(soup))
                else:
                    print(f"No module name found in {filepath}")

            print(f"Processed {filepath}.")

# Start the processing from the root docs directory
process_directory(DOCS_DIR)
print("Processing complete.")
