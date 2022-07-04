#!/bin/bash
PLATFORM=$(uname -s)
echo Platform:${PLATFORM}
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_${PLATFORM}_amd64.tar.gz" | tar -xz -C /tmp
mv /tmp/eksctl /usr/local/bin
