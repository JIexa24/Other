#!/bin/bash
echo "deb https://download.docker.com/linux/debian $(lsb_release -c | awk '{print $2}') stable" > /etc/apt/sources.list.d/docker.list
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
