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

                # Extract the module name from the <code> tag inside any h1 tag
                h1_tags = soup.find_all('h1')
                for h1_tag in h1_tags:
                    print(f"Found h1 tag: {h1_tag}")
                    code_tag = h1_tag.find('code')
                    if code_tag and "br.player." in code_tag.text:
                        module_name = code_tag.text.split('br.player.')[-1]
                        print(f"Extracted module name: {module_name}")
                        break
                else:
                    print(f"No suitable h1 tag with code child found in {filepath}")
                    continue

                # Find all function names and prepend the module name if not already present
                for dt in soup.find_all('dt'):
                    function_name = dt.string
                    if function_name and not function_name.startswith(module_name + '.'):
                        print(f"Updating function name: {function_name} to {module_name}.{function_name}")
                        dt.string = module_name + '.' + function_name

                # Also update the <strong> tags within <dt> and <td class="name" nowrap>
                for strong_tag in soup.find_all('strong'):
                    if strong_tag.string and not strong_tag.string.startswith(module_name + '.'):
                        print(f"Updating strong tag text: {strong_tag.string} to {module_name}.{strong_tag.string}")
                        strong_tag.string = module_name + '.' + strong_tag.string

                for td_tag in soup.find_all('td', class_='name'):
                    a_tag = td_tag.find('a', href=True)
                    if a_tag and a_tag.string and not a_tag.string.startswith(module_name + '.'):
                        print(f"Updating a tag text: {a_tag.string} to {module_name}.{a_tag.string}")
                        a_tag.string = module_name + '.' + a_tag.string

                # Save the changes back to the file
                with open(filepath, 'w', encoding='utf-8') as file:
                    file.write(str(soup))

                print(f"Processed {filepath}.")

# Start the processing from the root docs directory
process_directory(DOCS_DIR)
print("Processing complete.")
