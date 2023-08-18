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

                    # Update function names inside <dt>
                    for dt in soup.find_all('dt'):
                        # Update function names inside <strong> tag within <dt>
                        strong_tag = dt.find('strong')
                        if strong_tag:
                            function_name = strong_tag.string
                            if function_name and not (module_name + '.' in function_name):
                                print(f"Updating function name in <strong> tag: {function_name} to {module_name}.{function_name}")
                                strong_tag.string.replace_with(module_name + '.' + function_name)

                        # Update function names inside <a> tag within <dt>
                        a_tag = dt.find('a')
                        if a_tag:
                            function_name = a_tag.string
                            if function_name and not (module_name + '.' in function_name):
                                print(f"Updating function name in <a> tag: {function_name} to {module_name}.{function_name}")
                                a_tag.string.replace_with(module_name + '.' + function_name)

                    # Update function names inside <td class="name" nowrap>
                    for td in soup.find_all('td', class_='name', nowrap=True):
                        # Update function names inside <a href> tag within <td>
                        a_tag = td.find('a')
                        if a_tag:
                            function_name = a_tag.string
                            if function_name and not (module_name + '.' in function_name):
                                print(f"Updating function name in <a href> tag: {function_name} to {module_name}.{function_name}")
                                a_tag.string.replace_with(module_name + '.' + function_name)
                                # Update the href attribute as well
                                a_tag['href'] = a_tag['href'].replace(function_name, module_name + '.' + function_name)

                        # Update the corresponding text inside <td>
                        if td.string and not (module_name + '.' in td.string):
                            print(f"Updating function name in <td> text: {td.string} to {module_name}.{td.string}")
                            td.string.replace_with(module_name + '.' + td.string)

                    # Save the changes back to the file
                    with open(filepath, 'w', encoding='utf-8') as file:
                        file.write(str(soup))
                else:
                    print(f"No module name found in {filepath}")

            print(f"Processed {filepath}.")

# Start the processing from the root docs directory
process_directory(DOCS_DIR)
print("Processing complete.")
