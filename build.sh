#!/bin/bash

# Directory containing the source files
SRC_DIR="./native"

# Output directory for the shared libraries
OUT_DIR="./android/app/libs"

# Create the output directory if it doesn't exist
mkdir -p "$OUT_DIR"

# Loop through all .c files in the source directory
for src_file in "$SRC_DIR"/*.c; do
    # Get the base name of the source file (without directory and extension)
    base_name=$(basename "$src_file" .c)
    
    # Print a message indicating which file is being compiled
    echo "Compiling $src_file to $OUT_DIR/$base_name.so"
    
    # Compile the source file into a shared library
    gcc -shared -o "$OUT_DIR/$base_name.so" "$src_file"
    
    # Check if the compilation was successful
    if [ $? -eq 0 ]; then
        echo "Successfully compiled $src_file"
        
        # Copy the source file to the output directory
        cp "$src_file" "$OUT_DIR/"
        if [ $? -eq 0 ]; then
            echo "Successfully copied $src_file to $OUT_DIR/"
        else
            echo "Failed to copy $src_file to $OUT_DIR/"
            exit 1
        fi
    else
        echo "Failed to compile $src_file"
        exit 1
    fi
done

echo "All files compiled and copied successfully."