#!/bin/bash

# Helper function shows how to use the command
USAGE()
{
cat << EOF

USAGE: $./$(basename "$0") [-h|-s|-b|-r] (filename) (hostname) (ipaddress)
Options:
    -h) Opens helper to see options and arguments needed (optional)
    -s) Search for IP address or hostname and copy the match into a file. Print matchese on STDOUT (optional)
    -b) Search for IP address by hostname and replace old ip with new ip and copy update into a file. Print updates on STDOUT (optional)
    -r) Search for IP address or hostname and delete the match and copy update into a file. Print deleted on STDOUT (optional)

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

## search ip addresses or hostname
## then print the match on STDOUT
## copy the matched result into a new file
SEARCH_IPADDRESS_OR_HOSTNAME()
{
  ## initialize variables
  MATCHED_LINES=""
  UPDATED_CONTENT=""

  ## get given file contents
  FILE_CONTENT=$(cat "${1}")

  ## check if file contains ip_address or host_name
  if [[ "${FILE_CONTENT}" =~ "${2}" || "${FILE_CONTENT}" =~ "${3}" ]]; then
    ## get original filename
    FILE_NAME=$(basename -- "${1}")

    ## form new file name
    FILE_NAME="${FILE_NAME%.*}.upd3"

    ## store found matches to a variable for STDOUT
    ## copy found matches to a new file
    while IFS= read -r LINE; do
      ## find given ip_address or host_name in the line
      if [[ $(egrep -o "${2}" <<< "${LINE}") == "${2}" || $(egrep -o "${3}" <<< "${LINE}") == "${3}" ]]; then
        ## finding ip_address in the line
        IPADDRESS=$(grep -o "[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}" <<< "${LINE}")

        ## check if line contains ip_address or not
        ## then print the updated line into the new file
        if [[ "${IPADDRESS}" != "" ]]; then
          ## store original line for STDOUT
          MATCHED_LINES+="${LINE}\n"

          ## store the matched line into file
          UPDATED_CONTENT+="${LINE}\n"
        fi
      fi
    done < "${1}"

    ## check if match found or not?
    if [[ "${MATCHED_LINES}" != "" ]]; then
      ## copy matched file contents to new file
      echo -en "Matched IP Addresses or Host Names:\n${UPDATED_CONTENT}\n" >> "tmp/${FILE_NAME}"

      ## print found matched and changed ip_address on STDOUT
      echo -en "\nMatched IP Addresses And Hostn Names:\n${MATCHED_LINES}\n"
    else
      ## print message if no match found
      echo -en "\nNo IP Address Or Host Name Found!\n\n"
    fi
  else
    ## print message if no match found
    echo -en "\nNo IP Address Or Host Name Found!\n\n"
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
    FILE_NAME="${FILE_NAME%.*}.upd3"

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

## search file contents and delete
## then print the deleted contents on STDOUT
## copy the deleted contents into a new file
SEARCH_CONTENTS_AND_DELETE()
{
  ## initialize variables
  DELETED_LINES=""
  UPDATED_CONTENT=""

  ## get given file contents
  FILE_CONTENT=$(cat "${1}")

  ## check if file contains ip_address or host_name
  if [[ "${FILE_CONTENT}" =~ "${2}" || "${FILE_CONTENT}" =~ "${3}" ]]; then
    ## get original filename
    FILE_NAME=$(basename -- "${1}")

    ## form new file name
    FILE_NAME="${FILE_NAME%.*}.upd3"

    ## store deleted contents to a variable for STDOUT
    ## copy deleted contents into a new file
    while IFS= read -r LINE; do
      ## find given ip_address or host_name in the line
      if [[ $(egrep -o "${2}" <<< "${LINE}") == "${2}" || $(egrep -o "${3}" <<< "${LINE}") == "${3}" ]]; then
        ## finding ip_address in the line
        IPADDRESS=$(grep -o "[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}" <<< "${LINE}")

        ## check if line contains ip_address or not
        ## then print the updated line into the new file
        if [[ "${IPADDRESS}" != "" ]]; then
          ## store deleted line for STDOUT
          DELETED_LINES+="${LINE}\n"

          ## store deleted line into file
          UPDATED_CONTENT+="# ${LINE}\n"
        else
          ## store the updated contents
          UPDATED_CONTENT+="${LINE}\n"
        fi
      else
        ## store the updated contents
        UPDATED_CONTENT+="${LINE}\n"
      fi
    done < "${1}"

    ## check if content deleted or not?
    if [[ "${DELETED_LINES}" != "" ]]; then
      ## copy deleted contents to new file
      echo -en "${UPDATED_CONTENT}\n" >> "tmp/${FILE_NAME}"

      ## print deleted contents on STDOUT
      echo -en "\nFollowing Lines Deleted:\n${DELETED_LINES}\n"
    else
      ## print message if no match found
      echo -en "\nNo Match Found For Deletion!\n\n"
    fi
  else
    ## print message if no match found
    echo -en "\nNo Match Found For Deletion!\n\n"
  fi
}

## call the helper if specified
while getopts ':hsbr:' OPTION; do
  case "$OPTION" in
    h) USAGE
       if [[ "${#}" -eq "1" ]]; then
          exit 0
       fi
       ;;
    s) shift ## shift left

       ## validate the arguments
       VALIDATE_ARGUMENTS "${@}"

       ## search ip_address or host_name
       SEARCH_IPADDRESS_OR_HOSTNAME "${@}"

       ## exit here once finished
       exit 0
       ;;
    b) shift ## shift left

       ## validate the arguments
       VALIDATE_ARGUMENTS "${@}"

       ## replace ip addresses by host name
       REPLACE_IP_BY_HOST_NAME "${@}"

       ## exit here once finished
       exit 0
       ;;
    r) shift ## shift left

       ## validate the arguments
       VALIDATE_ARGUMENTS "${@}"

       ## search contents and delete
       SEARCH_CONTENTS_AND_DELETE "${@}"

       ## exit here once finished
       exit 0
       ;;
   \?) printf "\nInvalid Option: -%s\n" "$OPTARG" >&2
       USAGE
       exit 1
       ;;
  esac
done
shift $((OPTIND -1))
