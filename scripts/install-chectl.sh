#!/bin/sh
if [ command -v chectl &> /dev/null ]; then
    echo "Chectl already installed"
    exit
fi
curl -sL  https://www.eclipse.org/che/chectl/ > che-install.sh
chmod +x ./che-install.sh
./che-install.sh
