#!/bin/bash

echo "1) To enter file names manually"
echo "2) To read file names from a file"
read num
case "$num" in
    1)
        echo "Enter path of files (space separated) to backup"
        read fpath
        tar -zcvpf backup-$(date "+%Y-%m-%d-%H-%M-%S").tar.gz $fpath
        if [ $? = 0 ]; then 
            echo "Backup is created successfully"
        else
            echo "Something went wrong"
        fi
        ;;
    2)
        echo "Enter path of file containing name of files to backup"
        read fpath
        tar -zcvpf backup-$(date "+%Y-%m-%d-%H-%M-%S").tar.gz $(< $fpath)
        if [ $? = 0 ]; then 
            echo "Backup is created successfully"
        else
            echo "Something went wrong"
        fi
        ;;
    *)
        echo "Exiting...";;
esac