#!/bin/bash

echo `git show --format="%h" HEAD | head -1` > build_info.txt
echo `git rev-parse --abbrev-ref HEAD` >> build_info.txt

export USER_NAME=mzabolotnov
docker build -t $USER_NAME/ui_crawler:1.0 .
