#!/bin/bash

# Display the UID and username of the user executing 


# Display UID
echo "Your ID is ${UID}"

# Only display if the UID does Notr match 1000
UID_TO_TEST_FOR="1000"

if [[ "${UID}" -ne "${UID_TO_TEST_FOR}" ]]
then
   echo "Your ID does not match ${UID_TO_TEST_FOR}"
   exit 1
fi

# Display the username
USER_NAME=$(id -un)

# Test if the command succeded
if [[ "${?}" -ne 0 ]]
then
   echo "The id command did not ezecute susccesfully"
   exit 1
fi
echo "Your username is ${USER_NAME}"

# You can use a string test conditional
USER_NAME_TO_TEST_FOR="vagrant"
if [[ "${USER_NAME}" = "${USER_NAME_TO_TEST_FOR}" ]]
then
   echo "Your username materials matches ${USER_NAME_TO_TEST_FOR}"
fi
# Test for +! for the string
if [[ "${USER_NAME}" != "${USER_NAME_TO_TEST_FOR}" ]]
then
   echo "Your username does not match ${USER_NAME_TO_TEST_FOR}"
   exit 1
fi

exit 0   
