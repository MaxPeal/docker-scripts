kill-all-docker() {
set -x
echo "#######################################"
docker system df
echo "#######################################"

docker ps -a -q | xargs -n 1 -P 8 -I {} docker stop {}
echo "#######################################"

docker buildx rm
echo "#######################################"

docker ps -a -q | xargs -n 1 -P 8 -I {} docker rm {}
echo "#######################################"

docker ps -a -q | xargs -n 1 -P 8 -I {} docker rmi {}
echo "#######################################"

docker image prune -a -f
echo "#######################################"

docker volume prune -f
echo "#######################################"

docker system df
echo "#######################################"
set +x
}
