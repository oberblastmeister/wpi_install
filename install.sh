#!/bin/bash

PROGNAME="$(basename "$0")"
DATE=$(date +'%Y')

error() {
    echo "${PROGNAME}: ${1:-"Unkown Error"}" 1>&2
    exit 1
}

cd ~/Downloads

echo "Installing wpilib archive file"
curl -fLo wpilib.tar.gz https://github.com/wpilibsuite/allwpilib/releases/download/v2020.3.2/WPILib_Linux-2020.3.2.tar.gz > /dev/null 2>&1 ||
    error "Failed to download wpilib archive file from github releases"

echo "Extracting wpilib archive file"
tar -xzf wpilib.tar.gz || error "Failed to extract wpilib tar file"

echo "Removing leftovers"
rm wpilib.tar.gz

echo "Moving stuff to the correct place"
mkdir -p "~/wpilib/$DATE"
mv wpilib/* "~/wpilib/$DATE"
rmdir wpilib

echo "Running ToolsUpdater.py"
cd "~/wpilib/$DATE"
python3 tools/ToolsUpdater.py > /dev/null 2>&1 || error "Failed to run python updator script"

echo "Installing vscode extensions"
for filename in vsCodeExtensions/*; do
    echo "Installing extension $filename"
    code --install-extension "$filename" > /dev/null 2>&1 || error "Failed to install extension $filename"
done
