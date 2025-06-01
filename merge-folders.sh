#!/bin/bash

# Prompt for source folder (default: ~/Downloads)
read -p "Enter the path to the source folder [default: ~/Downloads]: " source_input
source_input=${source_input:-~/Downloads}

# Prompt for destination folder (must be provided)
read -p "Enter the path to the destination folder: " dest_input
if [[ -z "$dest_input" ]]; then
  echo "❌ Destination folder path is required."
    exit 1
    fi

    # Expand ~ to $HOME
    source_dir="${source_input/#\~/$HOME}"
    dest_dir="${dest_input/#\~/$HOME}"

    # Create destination if it doesn't exist
    mkdir -p "$dest_dir"

    # Canonicalize destination path
    dest_dir_abs=$(cd "$dest_dir" && pwd)

    # Step 1: Unzip all zip files in the source folder
    echo "📦 Unzipping all .zip files in: $source_dir"
    for zip_file in "$source_dir"/*.zip; do
      [ -f "$zip_file" ] || continue
        unzip_dir="${zip_file%.zip}"
          echo "🔓 Unzipping: $zip_file"
            unzip -q "$zip_file" -d "$unzip_dir"
            done

            # Step 2: Merge all folders (excluding destination) into dest_dir
            for folder in "$source_dir"/*/; do
              [ -d "$folder" ] || continue

                folder_abs=$(cd "$folder" && pwd)
                  if [ "$folder_abs" = "$dest_dir_abs" ]; then
                      echo "⏭️  Skipping destination folder: $folder"
                          continue
                            fi

                              echo "📁 Merging contents of: $folder"
                                cp -nR "$folder"* "$dest_dir"

                                  echo "🗑️  Deleting folder: $folder"
                                    rm -r "$folder"
                                    done

                                    # Step 3: Delete all original .zip files
                                    echo "🗑️  Deleting all .zip files in: $source_dir"
                                    rm -f "$source_dir"/*.zip

                                    echo "✅ All zip files extracted, contents merged into: $dest_dir, and source zips/folders deleted."
