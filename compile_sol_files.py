import os
import shutil
import subprocess
import re
import solcx
from tqdm import tqdm
import json

# Set the path to the original dataset folder
original_dataset_path = 'sc_datasets/flattened_DAppSCAN'

# Set the path to the new dataset folder
new_dataset_path = 'sc_datasets/bytecode_DAppSCAN'

# Create the new dataset folder if it doesn't existß
if not os.path.exists(new_dataset_path):
    os.makedirs(new_dataset_path)

# Get the total number of Solidity files for progress tracking
total_dirs = sum(len(dirs) for _, dirs, _ in os.walk(original_dataset_path))

# List to store the names of files that failed to compile
failed_files = []

# Iterate over Solidity files in the original dataset folder with progress tracking
for root, _, files in tqdm(os.walk(original_dataset_path), total=total_dirs, unit='dir'):
    for file in files:
        if file.endswith('.sol'):
            file_path = os.path.join(root, file)

            try:
                with open(file_path, 'r') as fp:
                    content = fp.read()
                    pragma = re.search(r'pragma solidity.*', content, re.MULTILINE).group(0)

            except Exception as e:
                print(f'Error getting solc version for {file_path}: {e}')
                failed_files.append(file_path)
                continue

            if pragma:

                try:
                    solcx.set_solc_version_pragma(pragma)
                except Exception as e:
                    print(f'File: {file_path}')
                    print(f'Error setting solc version to {pragma}: {e}')



                # Compile the Solidity file using the appropriate solc version
                try:

                    with open(file_path, 'r') as f:
                        content = f.read()

                    result = solcx.compile_source(content, 
                                         output_values=["abi", "bin"],
                                         overwrite=True,
                                         allow_empty=True
                                         )
                
                    # Get the relative path within the original dataset folder
                    relative_path = os.path.relpath(file_path, original_dataset_path)
                    
                    # Create the corresponding subfolders in the new dataset directory
                    new_subfolder = os.path.join(new_dataset_path, os.path.dirname(relative_path))
                    os.makedirs(new_subfolder, exist_ok=True)
                    
                    # Write the compiled code to a new file in the new dataset directory as json
                    new_file_path = os.path.join(new_dataset_path, relative_path.strip('.sol') + '.json')
                    with open(new_file_path, 'w') as f:
                        json.dump(result, f, indent=4)

                    # print(f'Successfully compiled {file_path} .')
                    
                except Exception as e:
                    # print(f'Error compiling {file_path}: {e}')
                    failed_files.append(file_path)
            else:
                print(f'Skipping {file_path}: No pragma statement found.')

# Save the list of failed files to a text file
failed_files_path = os.path.join(new_dataset_path, 'failed_files.txt')
with open(failed_files_path, 'w') as file:
    file.write('\n'.join(failed_files))

print(f'Failed files saved to: {failed_files_path}')