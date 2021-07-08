#!/bin/bash
docker pull mongo:latest
echo `git show --format="%h" HEAD | head -1` > build_info.txt
echo `git rev-parse --abbrev-ref HEAD` >> build_info.txt
export USER_NAME=mzabolotnov
docker build -t $USER_NAME/ui_crawler:1.0 .
docker network create backnet
docker volume create mongo_db
docker run --rm -d --network=backnet --network-alias=mongo_db -v mongo_db:/data/db mongo:latest
docker run --rm -d --network=backnet -p 8000:8000 $USER_NAME/ui_crawler:1.0
