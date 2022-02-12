#!/bin/bash

# Install, start, enable services

if [ -z $1 ]; then
    echo "ERROR: Atleast one argument is required"
    exit 9
fi

for i in $@; do
    if [ $( sudo apt search $i | wc -l) -lt 3 ]; then
        echo "ERROR: Invalid argument"
        exit 8
    fi

    sudo apt install -y $i

    # Checks if atleast 256mb ram is available before starting a service
    FREE_MEM=$(free -m | grep -i 'mem' | awk '{ print $4 }')

    if [ $FREE_MEM -le 256 ]; then
        echo "ERROR: Low memory"
        exit 7
    fi

    sudo systemctl enable $i
    sudo systemctl start $i
done
exit 0