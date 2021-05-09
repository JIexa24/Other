#!/bin/sh
if [ $# -lt 3 ]; then
  printf 'docker run -d --name $1 --restart always --network host \
-v $2:/etc/nginx/conf.d $4 nginx:$3'
  printf "\nUsage: $(echo $0) <name> <config dir> <version> <other params>\n"
  exit 1
fi
docker run -d --name $1 --restart always --network host \
-v $2:/etc/nginx/conf.d $4 nginx:$3