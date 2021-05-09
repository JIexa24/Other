#!/bin/sh

if [ -z $1 ]; then
  echo "Usage: $0 <version>"
  exit 1
fi

curl -L "https://github.com/docker/compose/releases/download/${1}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose