#!/bin/bash
log()
{
  local MASSAGE="${@}"
  if [ "${VERBOSE}"="true" ]
  then
    echo "${MASSAGE}"
  fi
  logger -t luser-demo10.sh "${MASSAGE}"
}

backup_file()
{
  # This function creates a backup of a file. Returns non-zero status on error
  local FILE="${1}"

  # make sure the file exist
  if [ -f "${FILE}" ]
  then
    local BACKUP_FILE="/var/tmp/$(basename ${FILE}).$(date +%F-%N)"
    log "Backing up ${FILE} to ${BACKUP_FILE}"

    #The exit status of the function will be the exit status of the cp command
    cp -p ${FILE} ${BACKUP_FILE}
  else
    # the file does not exist, so return a non-zero exit status
    return 1
  fi
}

readonly VERBOSE='true'
log "Hello !"
log "This is funnn!"

backup_file '/etc/passwd'

# Make a decision based on the exit status of the function
if [[ "${?}" -eq '0' ]]
then
  log 'file backup succeeded!'
else
  log 'file backup failed!!'
  exit 1
fi
