#!/usr/bin/env bash

# If pwd / depot_tools does not exist, clone it
if [ ! -d "$(pwd)/depot_tools" ]; then
    echo "Cloning depot_tools into $(pwd)/depot_tools"
    git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
else
    echo "depot_tools already exists in $(pwd)/depot_tools"
fi

if [ ! -d "$(pwd)/chromium" ]; then
    echo "Fetching chromium source code into $(pwd)/chromium"
    fetch --no-history chromium
else
    echo "chromium directory already exists in $(pwd)/chromium"
fi
