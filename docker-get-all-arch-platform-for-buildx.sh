docker buildx ls | cut -d" " -f1 | grep -v "/" | \
  while read line; do
   docker buildx rm $line
  done

docker run --rm --privileged multiarch/qemu-user-static --reset -p yes

docker buildx create --use
docker buildx inspect --bootstrap
docker buildx inspect --bootstrap

docker buildx bake --platform $(docker buildx inspect --bootstrap | grep -i Platforms | cut -d":" -f2 | tr -d "[:space:]") <<<"RUN uname"

docker buildx ls | cut -d" " -f1 | grep -v "/" | \
  while read line; do
   docker buildx rm $line
  done
