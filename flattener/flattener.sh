#!/bin/bash

# Set the input and output directories
input_dir="../sc_datasets/DAppSCAN"
output_dir="flattened_contracts"

# Create the output directory if it doesn't exist
mkdir -p "$output_dir"

# Find all the Solidity files in the input directory and its subdirectories
find "$input_dir" -name "*.sol" | while read file_path; do
  # Get the relative path of the file
  relative_path="${file_path#$input_dir/}"
  # Create the output directory for the file if it doesn't exist
  mkdir -p "$output_dir/$(dirname "$relative_path")"
  # Flatten the file and write the output to the corresponding output file
  truffle-flattener "$file_path" > "$output_dir/$relative_path"
done