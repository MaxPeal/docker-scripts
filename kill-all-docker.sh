kill-all-docker() { set -x 
docker system df
docker ps -a -q | xargs -n 1 -P 8 -I {} docker stop {}
docker buildx rm
docker ps -a -q | xargs -n 1 -P 8 -I {} docker rm {}
docker ps -a -q | xargs -n 1 -P 8 -I {} docker rmi {}
docker image prune -a -f
docker volume prune -f
docker system df }
