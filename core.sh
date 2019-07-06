#!/bin/bash

CUSTOM_HEADERS="Server: basHttpd/1.0 ( $(uname -o) $(uname -r) )\r\n"

LOG_FILE="logs/"$(date +%Y-%m-%d)
WEB_FILES_PATH=./web
INDEXER="ls -l"

FILE=$(head -1 /dev/stdin)
FILE=$WEB_FILES_PATH$(echo $FILE | cut -d " " -f 2)

# echo $FILE

if [ ! -e "$FILE" ]; then
    HEADERS="HTTP/1.1 404 Not Found"
    echo "file not found" > tmp
    echo "[ $(date +%H:%M:%S) ][ ERROR ] File not found \"$FILE\"" >> $LOG_FILE
elif [ -f "$FILE" ]; then
    HEADERS="HTTP/1.1 200 OK"
    HEADERS=$HEADERS"\r\nContent-Type:"$(file $FILE --mime | cut -d ":" -f 2)
    cat $FILE > tmp
    echo "[ $(date +%H:%M:%S) ][ SUCCESS ] File access \"$FILE\"" >> $LOG_FILE
elif [ -d "$FILE" ]; then
    HEADERS="HTTP/1.1 200 OK\r\nContent-Type: text/plain; charset=utf-8"
    $INDEXER $FILE > tmp
    echo "[ $(date +%H:%M:%S) ][ SUCCESS ] Dir access \"$FILE\"" >> $LOG_FILE
fi

echo -e $HEADERS
echo -e $CUSTOM_HEADERS
cat tmp
