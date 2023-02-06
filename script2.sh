#!/bin/bash

# Helper function shows how to use the command
USAGE()
{
cat << EOF

USAGE: $./$(basename "$0") [-h] (filename) (hostname) (ipaddress)
Options:
    -h) Opens helper to see options and arguments needed (optional)

Mendatory Arguments:
    filename  : Provide "file_name" or "file_full_path" to search
    hostname  : Provide "host_name" as a search keyword
    ipaddress : Provide new "ip_address" for replacing the old one

EOF
}

## checks the mendatory arguments and validate them
VALIDATE_ARGUMENTS()
{
  ## check for mendatory agruments
  if [[ "${#}" -lt "3" ]]; then
    printf "\nAll the mendatory arguments are not supplied! Please check the usage below!\n"
    USAGE
    exit 1
  fi

  ## check if file exists or not?
  if [[ ! -f "${1}" ]]; then
    printf "\nSearch file doesn't exist in the system! Please check the usage below!\n"
    USAGE
    exit 1
  fi
}

# replaces ip addresses by host name
REPLACE_IP_BY_HOST_NAME()
{
  ## initialize variables
  UPDATED_CONTENT=""
  CHANGED_ADDRESSES=""

  ## get given file contents
  FILE_CONTENT=$(cat "${1}")

  ## check if file contains host-name
  if [[ "${FILE_CONTENT}" =~ "${2}" ]]; then
    ## get original filename
    FILE_NAME=$(basename -- "${1}")

    ## form new file name
    FILE_NAME="${FILE_NAME%.*}.upd2"

    ## copy original file contents to new file
    while IFS= read -r LINE; do
      ## find given host name in the line
      if [[ $(egrep -o "${2}" <<< "${LINE}") == "${2}" ]]; then
        ## finding ip_address in the line
        IPADDRESS=$(grep -o "[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}" <<< "${LINE}")

        ## replace ip_address with the new one and
        ## then print the updated line into the new file
        if [[ "${IPADDRESS}" != "" ]]; then
          ## store original line for STDOUT
          CHANGED_ADDRESSES+="(${LINE}) => changed to => "

          ## replace ip_address with new one
          UPDATED_LINE="${LINE//$IPADDRESS/$3}"

          ## store the updated line for file
          UPDATED_CONTENT+="${UPDATED_LINE}\n"

          ## store updated line for STDOUT
          CHANGED_ADDRESSES+="(${UPDATED_LINE})\n"
        else
          ## store the updated contents
          UPDATED_CONTENT+="${LINE}\n"
        fi
      else
        ## store the updated contents
        UPDATED_CONTENT+="${LINE}\n"
      fi
    done < "${1}"

    ## check if match found or not?
    if [[ "${CHANGED_ADDRESSES}" != "" ]]; then
      ## copy modified file contents to new file
      echo -en "${UPDATED_CONTENT}\n" >> "tmp/${FILE_NAME}"

      ## print found matched and changed ip_address on STDOUT
      echo -en "\nChanged IP Addresses:\n${CHANGED_ADDRESSES}\n"
    else
      ## print message if no match found
      echo -en "\nNo IP Address is Changed!\n\n"
    fi
  else
    ## print message if no match found
    echo -en "\nNo IP Address is Changed!\n\n"
  fi
}

## call the helper if specified
while getopts ':h' OPTION; do
  case "$OPTION" in
    h) USAGE
       if [[ "${#}" -eq "1" ]]; then
          exit 0
       fi
       ;;
   \?) printf "\nInvalid Option: -%s\n" "$OPTARG" >&2
       USAGE
       exit 1
       ;;
  esac
done
shift $((OPTIND -1))

## validate the arguments
VALIDATE_ARGUMENTS "${@}"

## replace ip addresses by host name
REPLACE_IP_BY_HOST_NAME "${@}"
