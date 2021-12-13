#!/bin/bash

# Make sure the script is being executed with superuser privileges
if [[ "${UID}" -ne 0 ]]
then
  echo "Please run use sudo or as root" >&2
  exit 1
fi

# If the user doesn't supply at least one argument, then give them help
if [[ "${#}" -lt 1 ]]
then
  echo "USAGE: ${0} USERNAME [COMMENT].." >&2
  echo "Create an account on the local system with the name of the USERNAME and a comments field of COMMENT" >&2
  exit 1
fi

# The first parameter is the username
USERNAME="${1}"

# The rest of the parameters are for the account comments
shift
COMMENT="${@}"

# generate a password
PASSWORD=$(date +%s%N | sha256sum | head -c48)

# create the user with the password
useradd -c "${COMMENT}" -m ${USERNAME} &> /dev/null

# Check to see if the useradd command succeeded
if [[ "${?}" -ne 0 ]]
then
  echo "The account could not be created" >&2
  exit 1
fi

# set the password
echo ${PASSWORD} | passwd --stdin ${USERNAME} &> /dev/null

# check to see if the password command succeeded
if [[ "${?}" -ne 0 ]]
then
  echo "Failed to add the password" >&2
  exit 1
fi

# force password change on the first login
#passwd -e ${USERNAME} &> /dev/null

echo ""
echo "Username : ${USERNAME}"
echo ""
echo "Password : ${PASSWORD}"
echo ""
echo "Host : ${HOSTNAME}"
exit 0
