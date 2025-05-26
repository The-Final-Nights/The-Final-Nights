#!/bin/bash
set -e
source dependencies.sh
echo "Downloading BYOND version $BYOND_MAJOR.$BYOND_MINOR"
curl "https://thefinalnights.com/516.1663_byond.zip" -o C:/byond.zip -A "The-Final-Nights/2.0 Continuous Integration"
