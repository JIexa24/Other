#!/bin/bash
# Script for request freeipa password.
# ./freeipa.sh -h ldap://ipa.example.com -b "cn=users,cn=accounts,dc=example,dc=com" | freeipa-decoder.py

while getopts "b:h:" opt; do
  case $opt in
  b) BASE_DN=${OPTARG} ;;
  h) HOST=${OPTARG} ;;
  esac
done

BASE_DN=${BASE_DN:-}
HOST=${HOST:-}

if [ -z ${BASE_DN} ]; then
  echo "BASE_DN (-b) for users must be specified"
  exit 1
fi

if [ -z ${HOST} ]; then
  echo "HOST (-h) must be specified"
  exit 1
fi

ldapsearch -H "${HOST}" -D "cn=Directory Manager" -b "${BASE_DN}" -W "(!(nsaccountlock=TRUE))" uid userPassword
