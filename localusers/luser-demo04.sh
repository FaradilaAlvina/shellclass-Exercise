#!/bin/bash

# This script creates an account on the local system
# You will be prompted for the account name and password


# Ask for the username
read -p "Enter a username to create: " USER_NAME
# Ask for the real name
read -p "Enter a name of the person who this account: " COMMENT
# Ask for the password
read -p "Enter the password to use for the account: " 
PASSWORD

# Create user
useradd -c "${COMMENT}" -m "${USER_NAME}"

# Set the password for the user
echo ${PASSWORD} | passwd --stdin ${USER_NAME}

# Force password change on first login
passwd -e ${USER_NAME}
