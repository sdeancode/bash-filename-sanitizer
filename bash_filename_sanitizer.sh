#!/bin/bash
# authored by: Sean Dean
# version: 2.0

# this is a simple script whose purpose is to sanitize file names
#   within a folder.  Allowed characters are [a-z0-9._-].  Uppercase letters
#   are translated to lower case, spaces are translated to underscores, and
#   all other characters are removed.  Excessive hyphens and underscores are
#   reduced down to a single hyphen or underscore, and cases of sequential
#   hyphen and underscore usage and converted into a single underscore.

# make the script exit on error.
set -e

# remove the space from the internal field separator to prevent
#   issues with renaming files with spaces
IFS=$'\n\t'

# create a pseudo-random string so that files that do not rename
#   properly can still have a unique file name, and do not get
#   overwritten by other improper filename renames.
random_tag=$(date +%s)

folder_files=()

# add a '_renamed-' string to the end of each file being renamed
for file in *; do
  if [[ $file =~ [^a-z0-9._-] ]]; then
    rename "s/$/_renamed-$random_tag/" $file
  fi 
done

# looks for files with the '_renamed-' tag, and adds them to the
#   folder_files array.
for file in *; do
  if [[ $file =~ "_renamed-" ]]; then
    folder_files+=("$file")
  fi
done

# takes files within the folder_files array and processes each file
#   according to the following rules:
#   * translates uppercase letters to lowercase
#   * translates spaces to underscores
#   * removes all non-alphanumeric, period, underscore or hyphen characters.
#   * converts all instances of sequential underscores to a single underscore.
#   * converts all instances of sequential hyphens to a single hyphen.
#   * converts all cases of sequential underscores and hyphens to a single underscore.
for i in "${folder_files[@]}"; do
  echo "renaming $i"
  folder_files=("${folder_files[@]/$i}")
  rename 'y/[A-Z]/[a-z]/; y/ /_/; s/[^a-zA-Z0-9._-]//g; s/_+/_/g; s/-+/-/g; s/(-_-|_-_|-_|_-)/_/g' $i
done

# removes the _renamed- tag and the randomized date string, unless
#   the original file name was completely removed, in which case
#   the file name is updated to reflect this, and left with
#   the date string.
for file in *; do
  if [[ $file =~ "_renamed-" ]]; then
    if [[ $file =~ ^_renamed- ]]; then
      rename 's/_renamed-/empty_string_post_rename-/' $file
    else
      rename 's/_renamed-\d+?$//' $file
    fi
  fi
done
