#!/bin/bash

## initialize variables
FIND_AND_REPLACE_IP()
{
  TEMP_DIR="./tmp"
  FIND_THIS="192.168.10."
  REPLACE_WITH="192.168.20."

  ## loop through all the files in the directory
  for FULL_PATH in "$TEMP_DIR"/*; do
    ## get current file contents
    FILE_CONTENT=$(cat "${FULL_PATH}")

    ## check if file contains 192.168.10.
    if [[ "${FILE_CONTENT}" =~ "${FIND_THIS}" ]]; then
      ## get original filename
      FILE_NAME=$(basename -- "${FULL_PATH}")
      FILE_NAME="${FILE_NAME%.*}.upd"

      ## replace matched contents with 192.168.20.
      FILE_CONTENT="${FILE_CONTENT//$FIND_THIS/$REPLACE_WITH}"

      ## copy modified file contents to new file
      echo -en "${FILE_CONTENT}\n" >> "tmp/${FILE_NAME}"
    fi
  done
}

## find and replace ip address
FIND_AND_REPLACE_IP
