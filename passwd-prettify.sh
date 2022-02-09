#!/bin/bash

while read line; do
    echo "--------------------------------------"
    echo "Username : $(echo $line | cut -d ":" -f1)"
    echo "Password : $(echo $line | cut -d ":" -f2)"
    echo "UID : $(echo $line | cut -d ":" -f3)"
    echo "GID : $(echo $line | cut -d ":" -f4)"
    echo "Full Name : $(echo $line | cut -d ":" -f5)"
    echo "Home Directory : $(echo $line | cut -d ":" -f6)"
    echo "Login Shell : $(echo $line | cut -d ":" -f7)"
    echo "--------------------------------------"
done < /etc/passwd