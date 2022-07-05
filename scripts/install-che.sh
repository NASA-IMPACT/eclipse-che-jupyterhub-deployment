#!/bin/bash
PLATFORM=$(uname -s)
CHECTL_VERSION=7.49.0
curl -sL "https://github.com/che-incubator/chectl/releases/download/${CHECTL_VERSION}/chectl-${PLATFORM}-x64.tar.gz" > ./scripts/che-install.sh
chmod +x ./scripts/che-install.sh
./scripts/che-install.sh