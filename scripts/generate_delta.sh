#!/bin/bash

set -o nounset

error() {
  echo error: $1, please try again >&2
  echo "Usage: $0 device oldversion newversion"
  exit 1
}

[[ $# -eq 3 ]] ||  error "incorrect number of arguments"

DEVICE=$1
KEY_DIR=keys
OLD=$2
NEW=$3

if [[ -d build/tools/releasetools ]]; then
  RELEASETOOLS_PATH=build/tools
else
  # For usage with otatools.zip
  RELEASETOOLS_PATH=.
fi

$RELEASETOOLS_PATH/releasetools/ota_from_target_files -p . -k "$KEY_DIR/releasekey" \
  -i archive/release-$DEVICE-$OLD/$DEVICE-target_files-$OLD.zip \
  archive/release-$DEVICE-$NEW/$DEVICE-target_files-$NEW.zip \
  archive/release-$DEVICE-$NEW/$DEVICE-incremental-$OLD-$NEW.zip