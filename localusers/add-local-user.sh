#!/bin/bash

# Make sure the script is being executed with superuser privileges.
if [[ "${UID}" -ne 0 ]]
then
   echo "RUN WITH ROOT USER !!" >&2
   exit 1
fi

# If the user doesn't supply at least one argument, then give them help.
if [[ "${#}" -lt 1 ]]
then
   echo "USAGE: ${0} USERNAME [COMMENT]..." >&2
   echo "Create an account on the local system with the name of the USERNAME and a comments field of COMMENT" >&2
   exit 1
fi

# The first parameter is the user name.
USERNAME="${1}"

# The rest of the parameters are for the account comments.
shift
COMMENT="${@}"

# Generate a password.
PASSWORD=$(date +%s%N | sha256sum | head -c48)

# Create the user with the password.
useradd -c "${COMMENT}" -m ${USERNAME} &> /dev/null

# Check to see if the useradd command succeeded.
if [[ "${?}" -ne 0 ]]
then
   echo "The account could not be created" >&2
   exit 1
fi


# Set the password.
echo ${PASSWORD} | passwd --stdin ${USERNAME} &> /dev/null


# Check to see if the passwd command succeeded.
if [[ "${?}" -ne 0 ]]
then
   echo "Failed to add the password" >&2
   exit 1
fi

# Force password change on first login.
passwd -e ${USERNAME} &> /dev/null

# Display the username, password, and the host where the user was created.
echo ""
echo "Username : ${USERNAME}"
echo ""
#echo "Full name : ${NAME}"
#echo ""
echo "Password : ${PASSWORD}"
echo ""
echo "Host : ${HOSTNAME}"
exit 0






# Add user
#useradd -c "${NAME}" -m ${USERNAME}

# Check if the user success created
#if [[ "${?}" -ne 0 ]]
#then
#   echo "The account could not be created."
#   exit 1
#fi

# Set the password
#echo ${PASSWORD} | passwd --stdin ${USERNAME}

#if [[ "${?}" -ne 0 ]]
#then
#   echo "Failed to add the password."
#   exit 1
#fi


# Force password for first login
#passwd -e ${USERNAME}

# Display the account
#echo ""
#echo "Username : ${USERNAME}"
#echo ""
#echo "Full name : ${NAME}"
#echo ""
#echo "Password : ${PASSWORD}"
#echo ""
#echo "Host : ${HOSTNAME}"
#exit 0
