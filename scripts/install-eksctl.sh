#!/bin/bash
if [ command -v eksctl &> /dev/null ]; then
    echo "Eksctl already installed"
    exit
fi

PLATFORM=$(uname -s)
URL="https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_${PLATFORM}_amd64.tar.gz"
echo Platform:${PLATFORM}
echo "Download URL:${URL}"
curl --silent --location "${URL}" | tar -xz -C /tmp
mv /tmp/eksctl /usr/local/bin
