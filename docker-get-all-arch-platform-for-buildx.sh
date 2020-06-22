docker buildx ls | cut -d" " -f1 | grep -v "/" | \
  while read line; do
   docker buildx rm $line
  done

docker run --rm --privileged multiarch/qemu-user-static --reset -p yes

docker buildx create --use
docker buildx inspect --bootstrap
docker buildx inspect --bootstrap

docker buildx build --platform linux/amd64,linux/arm64,linux/ppc64le,linux/s390x,linux/386,linux/arm/v7,linux/arm/v6 --tag testbox --progress plain -<<EOF
FROM busybox
RUN echo "hello world"
RUN uname -a
RUN uname -m
RUN getconf -a
EOF

linux/riscv64

docker manifest inspect alpine
docker manifest inspect busybox
docker manifest inspect docker
docker docker buildx inspect --bootstrap | grep -i Platforms | cut -d":" -f2 | tr -d "[:space:]"

 1055  docker manifest inspect library/docker
 1056  docker manifest inspect scratch
 1057  docker pull scratch
 1058  docker pull library/scratch
 1059  docker manifest inspect docker.io/library/docker
 1060  docker manifest inspect docker.io/library/busybox
 1061  docker manifest inspect docker.io/library/hello-world
 1062  docker manifest inspect docker.io/library/registry
 1063  docker manifest inspect docker.io/library/hello-world
 1064  docker manifest inspect docker.io/library/bash
 1065  docker manifest inspect docker.io/library/toybox
 1066  docker manifest inspect docker.io/library/uname
 1067  docker manifest inspect docker.io/library/ubuntu
 1068  docker manifest inspect docker.io/library/debian
 1069  docker manifest inspect docker.io/library/alpine
 1070  docker manifest inspect docker.io/library/busybox
 1071  docker buildx inspect
 1072  buildx ls
 1073  docker buildx ls
 1074  docker manifest inspect docker.io/library/buildkit
 1075  docker manifest inspect docker.io/library/buildKit
 1076  docker manifest inspect docker.io/library/buildx
 1077  docker manifest inspect docker.io/library/hello-world



#docker buildx bake --platform $(docker buildx inspect --bootstrap | grep -i Platforms | cut -d":" -f2 | tr -d "[:space:]") <<<"RUN uname"

docker buildx ls | cut -d" " -f1 | grep -v "/" | \
  while read line; do
   docker buildx rm $line
  done








docker buildx ls | cut -d" " -f1 | grep -v "/" | \
  while read line; do
   docker buildx rm $line
  done

docker run --rm --privileged multiarch/qemu-user-static --reset -p yes

docker buildx create --use
docker buildx inspect --bootstrap
docker buildx inspect --bootstrap

docker buildx bake --platform $(docker buildx inspect --bootstrap | grep -i Platforms | cut -d":" -f2 | tr -d "[:space:]") <<<"RUN uname"

docker build --platform - < Dockerfile

docker build --platform linux/amd64,linux/arm64,linux/riscv64,linux/ppc64le,linux/s390x,linux/386,linux/arm/v7,linux/arm/v6 -<<EOF
docker build -<<EOF


docker buildx build --platform linux/amd64,linux/arm64,linux/riscv64,linux/ppc64le,linux/s390x,linux/386,linux/arm/v7,linux/arm/v6 --tag testbox --progress plain -<<EOF
FROM busybox
RUN echo "hello world"
RUN uname -a
RUN uname -m
EOF

docker buildx build --platform linux/amd64,linux/arm64,linux/ppc64le,linux/s390x,linux/386,linux/arm/v7,linux/arm/v6 --tag testbox --progress plain -<<EOF
FROM busybox
RUN echo "hello world"
RUN uname -a
RUN uname -m
RUN getconf -a
EOF


docker buildx ls | cut -d" " -f1 | grep -v "/" | \
  while read line; do
   docker buildx rm $line
  done
