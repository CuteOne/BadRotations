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
                if h1_tag:
                    print(f"Found h1 tag: {h1_tag}")
                    code_tag = h1_tag.find('code')
                    if code_tag:
                        print(f"Found code tag: {code_tag}")
                        if "br.player." in code_tag.text:
                            module_name = code_tag.text.split('br.player.')[-1]
                            print(f"Extracted module name: {module_name}")

                            # Find all function names and prepend the module name if not already present
                            for dt in soup.find_all('dt'):
                                function_name = dt.string
                                if function_name and not function_name.startswith(module_name + '.'):
                                    print(f"Updating function name: {function_name} to {module_name}.{function_name}")
                                    dt.string = module_name + '.' + function_name

                            # Additional logic for <strong> tags within <dt> and <td class="name" nowrap>
                            for strong_tag in soup.find_all('strong'):
                                if strong_tag.string and not strong_tag.string.startswith(module_name + '.'):
                                    print(f"Updating strong tag: {strong_tag.string} to {module_name}.{strong_tag.string}")
                                    strong_tag.string = module_name + '.' + strong_tag.string

                            for td_tag in soup.find_all('td', class_='name'):
                                for child in td_tag.children:
                                    if child.name == 'a' and child.string and not child.string.startswith(module_name + '.'):
                                        print(f"Updating td tag a href: {child['href']} to {module_name}.{child['href']}")
                                        child['href'] = module_name + '.' + child['href']
                                        print(f"Updating td tag a text: {child.string} to {module_name}.{child.string}")
                                        child.string = module_name + '.' + child.string

                        else:
                            print(f"No 'br.player.' found in code tag: {code_tag.text}")
                    else:
                        print(f"No code tag found inside h1 tag in {filepath}")
                else:
                    print(f"No h1 tag found in {filepath}")

                # Save the changes back to the file
                with open(filepath, 'w', encoding='utf-8') as file:
                    file.write(str(soup))

            print(f"Processed {filepath}.")

# Start the processing from the root docs directory
process_directory(DOCS_DIR)
print("Processing complete.")
