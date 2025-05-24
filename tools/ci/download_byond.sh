#!/bin/bash
set -e
source dependencies.sh
echo "Downloading BYOND version $BYOND_MAJOR.$BYOND_MINOR"
curl "http://www.thefinalnights.com/516.1655_byond_linux.zip" -o C:/byond.zip -A "The-Final-Nights/2.0 Continuous Integration"
