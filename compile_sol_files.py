import os
import shutil
import subprocess
import re
import solcx
from tqdm import tqdm

def setup_solc(version):

    # Install the required solc version if not already installed
    print(solcx.get_installed_solc_versions())
    if version not in solcx.get_installed_solc_versions():
        print(f"Installing solc version {version}...")
        solcx.install_solc(version)
        print(f"solc version {version} installed.")

def get_solc_version(file_path):
    with open(file_path, 'r') as file:
        content = file.read()
        pragma_match = re.search(r'pragma solidity ([^\s;]+)', content)
        if pragma_match:
            return pragma_match.group(1)
        else:
            return None

# Set the path to the original dataset folder
original_dataset_path = 'sc_datasets/flattened_DAppSCAN'

# Set the path to the new dataset folder
new_dataset_path = 'sc_datasets/compiled_DAppSCAN'

# Create the new dataset folder if it doesn't exist
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
            solc_version = get_solc_version(file_path)

            if solc_version:

                # Strip the '^' prefix from the version number
                version = solc_version[1:] if solc_version.startswith('^') else solc_version

                # Strip the '>=' suffix from the version number
                version = version[2:] if version.startswith('>=') else version

                try:
                    # Set up solc and install the required version if necessary
                    setup_solc(version)
                
                except Exception as e:
                    print(f'Error setting up solc version {version}: {e}')
                    failed_files.append(file_path)
                    continue

                # Compile the Solidity file using the appropriate solc version
                try:

                    print(f'Compiling {file_path} with solc version {version}...')

                    # Set the solc version to use
                    solcx.set_solc_version(version)

                    solcx.compile_files([file_path], 
                                         output_values=["bin"])                    
                    # Get the relative path within the original dataset folder
                    relative_path = os.path.relpath(file_path, original_dataset_path)
                    
                    # Create the corresponding subfolders in the new dataset directory
                    new_subfolder = os.path.join(new_dataset_path, os.path.dirname(relative_path))
                    os.makedirs(new_subfolder, exist_ok=True)
                    
                    # Copy the original file to the new dataset folder
                    new_file_path = os.path.join(new_dataset_path, relative_path)
                    shutil.copy(file_path, new_file_path)

                    print(f'Successfully compiled {file_path} with solc version {version}.')
                    
                except Exception as e:
                    print(f'Error compiling {file_path}: {e}')
                    failed_files.append(file_path)
            else:
                print(f'Skipping {file_path}: No pragma statement found.')

# Save the list of failed files to a text file
failed_files_path = os.path.join(new_dataset_path, 'failed_files.txt')
with open(failed_files_path, 'w') as file:
    file.write('\n'.join(failed_files))

print(f'Failed files saved to: {failed_files_path}')