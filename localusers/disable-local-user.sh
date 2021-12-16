#!/bin/bash
#
# This script disables, deletes, and/or archives users on the local system
# ensure this script running using user privileges or ROOT
#

ARCHIVE_DIR='/archive'

usage() {
  # Display the usage and exit
  echo "Supply an account name on the command line" >&2
  echo "USAGE: ${0} [-dra] USER [USERNAME]..." >&2
  echo "Disables a local linux account" >&2
  echo "  -d  Deletes accounts instead of disabling them" >&2
  echo "  -r  Removes the home directory associated with the accounts" >&2
  echo "  -a  Creates an archive of the home directory associated with the accounts" >&2
  exit 1
}

# Make sure the script executed on the root user
if [[ "${UID}" -ne 0 ]]
then
  echo "You Must Run with Root User!!" >&2
  exit 1
fi

# Parse the OPTION
while getopts dra OPTION
do
  case ${OPTION} in
    d) DELETE_USER='true';;
    r) REMOVE_OPTION='-r';;
    a) ARCHIVE='true';;
    ?) usage ;;
  esac
done

# remove the options while leaving the remaining arguments
shift $(( OPTIND - 1 ))

# If the user doesn't supply at least one argument, then give them help.
if [[ "${#}" -lt 1 ]]
then
  usage
fi

# Loop through all the username supplied as arguments
for USERNAME in "${@}"
do
  echo "Processing user: ${USERNAME}"

  # Make sure yout UID at least 1000
  USER_ID=$(id -u ${USERNAME})
  if [[ "${USER_ID}" -lt 1000 ]]
  then
    echo "Refusing to remove the ${USERNAME} account with user UID ${USER_ID}" >&2
    exit 1
  fi

  # Create an archive if requested to do so
  if [[ "${ARCHIVE}" = 'true' ]]
  then
    # Make sure the archive dir exist
    if [[ ! -d "${ARCHIVE_DIR}" ]]
    then
      echo "Creating ${ARCHIVE_DIR} directory"
      mkdir -p ${ARCHIVE_DIR}
      if [[ "${?}" -ne 0 ]]
      then
        echo "The archive directory ${ARCHIVE_DIR} could not be created" >&2
        exit 1
      fi
    fi

    # Archive the user's home directory and move it into the archive.id
    HOME_DIR="/home/${USERNAME}"
    ARCHIVE_FILE="${ARCHIVE_DIR}/${USERNAME}.tgz"
    if [[ -d "${HOME_DIR}" ]]
    then
      echo "Archiving ${HOME_DIR} to ${ARCHIVE_FILE}"
      tar -zcf ${ARCHIVE_FILE} ${HOME_DIR} &> /dev/null
      if [[ "${?}" -ne 0 ]]
      then
        echo "Could not create ${ARCHIVE_FILE}" >&2
        exit 1
      fi
    else
      echo "${HOME_DIR} does not exists is not a directory" >&2
      exit 1
    fi
  fi

  if [[ "${DELETE_USER}" = 'true' ]]
  then
    #Delete the user
    userdel ${REMOVE_OPTION} ${USERNAME}

    # check to see if the userdel commmand succeeded
    # we don't want to tell the user that an account was deleted when it hasn't been
    if [[ "${?}" -ne 0 ]]
    then
      echo "the account ${USERNAME} was not deleted" >&2
      exit 1
    fi
    echo "The account ${USERNAME} was deleted"
  else
    chage -E 0 ${USERNAME}
    # check to see if the chage commmand succeeded
    # we don't want to tell the user that an account was deleted when it hasn't been
    if [[ "${?}" -ne 0 ]]
    then
      echo "the account ${USERNAME} was not disabled" >&2
      exit 1
    fi
    echo "The account ${USERNAME} was disabled"
  fi
done

exit 0
