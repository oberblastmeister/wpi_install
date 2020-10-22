#!/bin/bash

PROGNAME="$(basename "$0")"
DATE=$(date +'%Y')
NEWDIR="$HOME/wpilib/$DATE"
TARFILE=wpilib.tar.gz

error() {
    printf "${PROGNAME}: ${1:-"Unkown Error"}\n" 1>&2
    exit 1
}

cleanup() {
    rm -f $TARFILE
}

interrupt() {
    printf "\nInterrupted\n"
    cleanup
}

trap cleanup EXIT
trap interrupt SIGINT

if [ -d "$NEWDIR" ]; then
    error "$NEWDIR exists. Please remove it to prevent this script from overriding the directory"
fi

cd ~/Downloads

while true; do
    read -p "Warning, wpilib will take a while to install. Continue? " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer y or n "
    esac
done

printf "\nDownloading wpilib from github\n\n"
curl --progress-bar -Lo $TARFILE https://github.com/wpilibsuite/allwpilib/releases/download/v2020.3.2/WPILib_Linux-2020.3.2.tar.gz ||
    error "Failed to download wpilib archive file from github releases"

printf "Extracting wpilib archive file\n\n"
tar -xzf $TARFILE || error "Failed to extract wpilib tar file"

mkdir -p "$NEWDIR"
mv wpilib/* "$NEWDIR"
rmdir wpilib

printf "Running ToolsUpdater.py\n\n"
cd "$HOME/wpilib/$DATE"
python3 tools/ToolsUpdater.py || error "Failed to run python updator script"

printf "Installing vscode extensions\n\n"
for filename in vsCodeExtensions/*; do
    printf "Installing extension $filename\n\n"
    code --install-extension "$filename\n\n" || error "Failed to install extension $filename"
done
