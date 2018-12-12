#!/bin/bash

# This script converts all csv files from a directory into pcd
# files in ASCII format. The script requires the PointCloudHandler
# software to be executable with command pch.

# To make make the pch executable, clone the PointCloudHandler
# repository from https://github.com/Martikain/PointCloudHandler.git
# Then build it with Qt
# Finally copy it to /usr/bin with:
# sudo cp path/to/PointCloudHandler /usr/bin/pch

dir=$1
pcd="_pcd"
outputDir="$dir$pcd"

# First argument is folder
if [ ! -d $dir ]; then
  echo "Directory does not exist!"
  exit 1
fi

if [ ! -d $outputDir ]; then
  mkdir "$outputDir"
fi

# Loop through all csv files in the directory
for filename in $dir/*.csv; do
  newfile="$filename"

  newfile=$(echo "$filename" | sed 's/.csv/.pcd/g')
  newfile=$(echo "$newfile" | sed "s/$dir//")
  newfile=$(echo "$newfile" | sed 's/ //g')
  newfile=$(echo "$newfile" | sed 's/\\//g')
  pch "convert" "-s" "$filename" "--delimiter" "," "-i" "intensity" "-d" "$outputDir/$newfile" "-f" "ASCII"
done

exit 0

