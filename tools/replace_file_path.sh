#!/bin/bash
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]
then
    echo "Usage: $0 PATH_LIST_FILE OLD_STRING NEW_STRING"
    exit
fi

while read line
do
    echo "sed -i.bak s/$2/$3/g $line"

    `sed -i.bak s/$2/$3/g $line`
done < $1

echo "done"
