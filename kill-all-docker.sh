#!/bin/sh
kill_all_docker() {
set -x
echo "#######################################"
docker system df
echo "#######################################"

# https://unix.stackexchange.com/questions/428310/problem-using-xargs-max-args-replace-with-default-delimiter
docker ps -a -q | xargs -P 8 -I {} docker stop {}
echo "#######################################"

docker builder prune -a -f
echo "#######################################"

docker buildx rm
echo "#######################################"

docker ps -a -q | xargs -P 8 -I {} docker rm {}
echo "#######################################"

docker ps -a -q | xargs -P 8 -I {} docker rmi {}
echo "#######################################"

docker image prune -a -f
echo "#######################################"

docker volume prune -f
echo "#######################################"

docker system df
echo "#######################################"
set +x
}
