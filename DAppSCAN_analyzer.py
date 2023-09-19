import os
import json
import tiktoken
import re
from tqdm import tqdm

def analyze_folders(root_dir):
    result = {}
    enc = tiktoken.encoding_for_model("gpt-3.5-turbo")
    for foldername in tqdm(os.listdir(root_dir)):
        full_folder_path = os.path.join(root_dir, foldername)
        if os.path.isdir(full_folder_path):
            folder_data = {
                'name': foldername,
                'file_count': 0,
                'files': []
            }
            for dirpath, _, filenames in os.walk(full_folder_path):
                for filename in filenames:
                    filepath = os.path.join(dirpath, filename)
                    file_size = os.path.getsize(filepath)
                    with open(filepath, 'r') as f:
                        text = f.read()
                        encoded = enc.encode(text)
                        token_sike = len(encoded)
                        pragma = re.search(r'pragma solidity.*', text, re.MULTILINE).group(0)
                        # Only keep the verison from pragma statement
                        version = None
                        if pragma:
                            version = pragma.split(' ')[2]

                    folder_data['file_count'] += 1
                    folder_data['files'].append({
                        'name': filename,
                        'length': file_size,
                        'token_length': token_sike,
                        'version': version
                    })
            result[foldername] = folder_data
    return result

def save_to_json(data, output_file):
    with open(output_file, 'w') as json_file:
        json.dump(data, json_file, indent=2)

if __name__ == "__main__":
    input_dir = "sc_datasets/compiled_DAppSCAN"
    output_file = "sc_datasets/compiled_DAppSCAN/analysis_result1.json"

    analysis_result = analyze_folders(input_dir)
    save_to_json(analysis_result, output_file)
    print("Analysis completed and saved to", output_file)
