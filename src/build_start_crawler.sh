#!/bin/bash
docker pull mongo:latest
docker pull rabbitmq:3-management-alpine
echo `git show --format="%h" HEAD | head -1` > build_info.txt
echo `git rev-parse --abbrev-ref HEAD` >> build_info.txt
export USER_NAME=mzabolotnov
docker build -t $USER_NAME/ui_crawler:1.0 .
docker build -t $USER_NAME/crawler:1.0 .
docker network create backnet
docker volume create mongo_db
docker volume create rabbit
docker run --rm -d --network=docker_back_net --network-alias=crawler_db -v mongo_db:/data/db mongo:latest
docker run --rm -d --network=docker_back_net --network-alias=rabbitmq -v rabbit:/var rabbitmq:3-management-alpine
docker run --rm -d --network=docker_back_net -p 8000:8000 $USER_NAME/ui_crawler:1.0
echo 'Pause 30s....'
sleep (30)
docker run --rm -d --network=docker_back_net --network-alias=crawler $USER_NAME/crawler:1.0
docker run --rm -d --network=docker_back_net -p 9090:9090 --name prometheus prom/prometheus