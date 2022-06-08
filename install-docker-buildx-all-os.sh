#!/bin/bash

{ # this ensures the entire script is downloaded #

set -x

function install_docker_buildx() {
set -x
#HFILE=buildx HASHcmd=sha256sum HASHSUM=3f4e77686659766a0726b5a47a87e2cc14c86ebf15abf7f19c45d23b0daff222 HURL=https://github.com/docker/buildx/releases/download/v0.4.1/buildx-v0.4.1.linux-amd64
#HFILE=docker-buildx HDIR=~/.docker/cli-plugins HASHcmd=sha256sum HASHSUM=3f4e77686659766a0726b5a47a87e2cc14c86ebf15abf7f19c45d23b0daff222 HURL=https://github.com/docker/buildx/releases/download/v0.4.2/buildx-v0.4.1.linux-amd64
###HFILE=docker-buildx HDIR=~/.docker/cli-plugins HASHcmd=sha256sum HASHSUM=c21f07356de93a4fa5d1b7998252ea5f518dbe94ae781e0edeec7d7e29fdf899 HURL=https://github.com/docker/buildx/releases/download/v0.4.2/buildx-v0.4.2.linux-amd64

#not working# HASHSUMx86_64=c21f07356de93a4fa5d1b7998252ea5f518dbe94ae781e0edeec7d7e29fdf899 HURLx86_64=https://github.com/docker/buildx/releases/download/v0.4.2/buildx-v0.4.2.linux-amd64
#not working# HASHSUMaarch64=c21f07356de93a4fa5d1b7998252ea5f518dbe94ae781e0edeec7d7e29fdf899 HURLaarch64=https://github.com/docker/buildx/releases/download/v0.4.2/buildx-v0.4.2.linux-amd64

#https://github.com/docker/buildx/releases/download/v0.4.2/buildx-v0.4.2.linux-amd64
#https://github.com/docker/buildx/releases/download/v0.4.2/buildx-v0.4.2.linux-arm-v6
#https://github.com/docker/buildx/releases/download/v0.4.2/buildx-v0.4.2.linux-arm-v7
#https://github.com/docker/buildx/releases/download/v0.4.2/buildx-v0.4.2.linux-arm64
#https://github.com/docker/buildx/releases/download/v0.4.2/buildx-v0.4.2.linux-ppc64le
#https://github.com/docker/buildx/releases/download/v0.4.2/buildx-v0.4.2.linux-s390x
#https://github.com/docker/buildx/releases/download/v0.4.2/buildx-v0.4.2.darwin-amd64
#https://github.com/docker/buildx/releases/download/v0.4.2/buildx-v0.4.2.windows-amd64.exe

#https://github.com/docker/buildx/releases/download/v0.8.2/buildx-v0.8.2.darwin-amd64
#https://github.com/docker/buildx/releases/download/v0.8.2/buildx-v0.8.2.darwin-arm64
#https://github.com/docker/buildx/releases/download/v0.8.2/buildx-v0.8.2.linux-amd64
#https://github.com/docker/buildx/releases/download/v0.8.2/buildx-v0.8.2.linux-arm-v6
#https://github.com/docker/buildx/releases/download/v0.8.2/buildx-v0.8.2.linux-arm-v7
#https://github.com/docker/buildx/releases/download/v0.8.2/buildx-v0.8.2.linux-arm64
#https://github.com/docker/buildx/releases/download/v0.8.2/buildx-v0.8.2.linux-ppc64le
#https://github.com/docker/buildx/releases/download/v0.8.2/buildx-v0.8.2.linux-riscv64
#https://github.com/docker/buildx/releases/download/v0.8.2/buildx-v0.8.2.linux-s390x
#https://github.com/docker/buildx/releases/download/v0.8.2/buildx-v0.8.2.windows-amd64.exe
#https://github.com/docker/buildx/releases/download/v0.8.2/buildx-v0.8.2.windows-arm64.exe
#https://github.com/docker/buildx/releases/download/v0.8.2/checksums.txt 

# 95303b8b017d6805d35768244e66b41739745f81cb3677c0aefea231e484e227  buildx-v0.8.2.darwin-amd64
# 145b51d31d04fc20486f5536267936fd5c25f02cdde8df91e255812cd41c4908  buildx-v0.8.2.darwin-arm64
# c64de4f3c30f7a73ff9db637660c7aa0f00234368105b0a09fa8e24eebe910c3  buildx-v0.8.2.linux-amd64
# d0e5d19cd67ea7a351e3bfe1de96f3d583a5b80f1bbadd61f7adcd61b147e5f5  buildx-v0.8.2.linux-arm-v6
# b5bb1e28e9413a75b2600955c486870aafd234f69953601eecc3664bd3af7463  buildx-v0.8.2.linux-arm-v7
# 304d3d9822c75f98ad9cf57f0c234bcf326bbb96d791d551728cadd72a7a377f  buildx-v0.8.2.linux-arm64
# 32b317d86c700d920468f162f93ae2282777da556ee49b4329f6c72ee2b11b85  buildx-v0.8.2.linux-ppc64le
# 76d5fcf92ffa31b3e470d8ec1ab11f7b6997729e5c94d543fec765ad79ad0630  buildx-v0.8.2.linux-riscv64
# ec4bb6f271f38dca5a377a70be24ee2108a85f6e6ba511ad3b805c4f1602a0d2  buildx-v0.8.2.linux-s390x
# abd54d5a589c7745b67990b4fdbd489c922864e3725353faf6859ceed835dd4a  buildx-v0.8.2.windows-amd64.exe
# 8fe575d9346d30e97240ee0dd85c22b5974e8ee898a5fd26ab0d7e6792bc3cf8  buildx-v0.8.2.windows-arm64.exe
# 539f924ef1ea1645f1e164472e183202fce11b608bccfeefe0f66e94f58bde57  checksums.txt


#HFILE=docker-buildx HDIR=~/.docker/cli-plugins HASHcmd=sha256sum HASHSUM=$HASHSUM$(uname -m) HURL=$HURL$(uname -m)
#HFILE=docker-buildx HDIR=~/.docker/cli-plugins HASHcmd=sha256sum HASHSUM=$(eval $HASHSUM$UNAMEM ) HURL=($HURL$UNAMEM)
HFILE=docker-buildx HDIR=~/.docker/cli-plugins HASHcmd=sha256sum 
HURLbase=https://github.com/docker/buildx/releases/download
#HURLver=v0.4.2
HURLver=v0.8.2
UNAMEM=$(uname -m)
UNAMEO=$(uname -o)
UNAMES=$(uname -s)
    case "$UNAMES" in \
        Linux*) OSvar='linux' ;; \
        *) echo >&2 "error: unsupported OS: UNAMEM: $UNAMEM, UNAMEO: $UNAMEO, UNAMES: $UNAMES,"; exit 1 ;; \
    esac &&
    
   case "$OSvar-$UNAMEM" in \
       linux-armhf) ARCH='arm' ;; \
       linux-armv6*) HURL=${HURLbase}/${HURLver}/buildx-${HURLver}.${OSvar}-arm-v6 ; HASHSUM=d0e5d19cd67ea7a351e3bfe1de96f3d583a5b80f1bbadd61f7adcd61b147e5f5 ;; \
       linux-armv7*) HURL=${HURLbase}/${HURLver}/buildx-${HURLver}.${OSvar}-arm-v7 ; HASHSUM=b5bb1e28e9413a75b2600955c486870aafd234f69953601eecc3664bd3af7463 ;; \
       linux-aarch64) HURL=${HURLbase}/${HURLver}/buildx-${HURLver}.${OSvar}-arm64 ; HASHSUM=304d3d9822c75f98ad9cf57f0c234bcf326bbb96d791d551728cadd72a7a377f ;; \
        linux-x86_64) HURL=${HURLbase}/${HURLver}/buildx-${HURLver}.${OSvar}-amd64 ; HASHSUM=c64de4f3c30f7a73ff9db637660c7aa0f00234368105b0a09fa8e24eebe910c3 ;; \
        linux-ppc64le) HURL=${HURLbase}/${HURLver}/buildx-${HURLver}.${OSvar}-ppc64le ; HASHSUM=32b317d86c700d920468f162f93ae2282777da556ee49b4329f6c72ee2b11b85 ;; \
        linux-riscv64) HURL=${HURLbase}/${HURLver}/buildx-${HURLver}.${OSvar}-riscv64 ; HASHSUM=76d5fcf92ffa31b3e470d8ec1ab11f7b6997729e5c94d543fec765ad79ad0630 ;; \
	linux-s390x) HURL=${HURLbase}/${HURLver}/buildx-${HURLver}.${OSvar}-s390x ; HASHSUM=ec4bb6f271f38dca5a377a70be24ee2108a85f6e6ba511ad3b805c4f1602a0d2 ;; \
        darwin-x86_64) HURL=${HURLbase}/${HURLver}/buildx-${HURLver}.${OSvar}-amd64 ; HASHSUM=95303b8b017d6805d35768244e66b41739745f81cb3677c0aefea231e484e227 ;; \
	darwin-aarch64) HURL=${HURLbase}/${HURLver}/buildx-${HURLver}.${OSvar}-arm64 ; HASHSUM=145b51d31d04fc20486f5536267936fd5c25f02cdde8df91e255812cd41c4908 ;; \
        windows-x86_64) HURL=${HURLbase}/${HURLver}/buildx-${HURLver}.${OSvar}-amd64 ; HASHSUM=abd54d5a589c7745b67990b4fdbd489c922864e3725353faf6859ceed835dd4a ;; \
	windows-aarch64) HURL=${HURLbase}/${HURLver}/buildx-${HURLver}.${OSvar}-amd64 ; HASHSUM=8fe575d9346d30e97240ee0dd85c22b5974e8ee898a5fd26ab0d7e6792bc3cf8 ;; \
        *) echo >&2 "error: unsupported architecture: UNAMEM: $UNAMEM, UNAMEO: $UNAMEO, UNAMES: $UNAMES,"; exit 1 ;; \
   esac &&




printf "HFILE=$HFILE HDIR=$HDIR HASHcmd=$HASHcmd HASHSUM=$HASHSUM HURL=$HURL"


( (cd $HDIR && printf %b $HASHSUM\\040\\052$HFILE\\012 | $HASHcmd -c -) && printf %b "SKIP DOWNLOAD\\040\\012" ) || curl -o $HFILE -LR -f -S --connect-timeout 15 --max-time 600 --retry 3 --dump-header - --compressed --verbose $HURL ; (printf %b CHECKSUM\\072\\040expect\\040this\\040$HASHcmd\\072\\040$HASHSUM\\040\\052$HFILE\\012 ; printf %b $HASHSUM\\040\\052$HFILE\\012 | $HASHcmd -c - ;) || (printf %b ERROR\\072\\040CHECKSUMFAILD\\072\\040the\\040file\\040has\\040this\\040$HASHcmd\\072\\040 ; $HASHcmd -b $HFILE ; exit 1) \
|| ( (cd $HDIR && printf %b $HASHSUM\\040\\052$HFILE\\012 | $HASHcmd -c -) && printf %b "SKIP DOWNLOAD\\040\\012" ) || wget -O $HFILE $HURL ; (printf %b CHECKSUM\\072\\040expect\\040this\\040$HASHcmd\\072\\040$HASHSUM\\040\\052$HFILE\\012 ; printf %b $HASHSUM\\040\\052$HFILE\\012 | $HASHcmd -c - ;) || (printf %b ERROR\\072\\040CHECKSUMFAILD\\072\\040the\\040file\\040has\\040this\\040$HASHcmd\\072\\040 ; $HASHcmd -b $HFILE ; exit 1) \
# FIXME
mkdir -p "${HDIR}"
mv "${HFILE}" "${HDIR}"/"${HFILE}" ||:
chmod 755 "${HDIR}"/"${HFILE}"
chmod a+x ~/.docker/cli-plugins/docker-buildx

  #+# docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
  # see https://github.com/multiarch/qemu-user-static/issues/38
  # see https://github.com/multiarch/qemu-user-static/issues/100
  #docker run --rm --privileged multiarch/qemu-user-static --reset
  #+# docker run --privileged --rm tonistiigi/binfmt --install all

  # Enable docker CLI experimental support (for 'docker buildx').
  #export DOCKER_CLI_EXPERIMENTAL=enabled
  # Instantiate docker buildx builder with multi-architecture support.
  #+#docker buildx create --name mybuilder
  #+#docker buildx use mybuilder
  # Start up buildx and verify that all is OK.
  #+#docker buildx inspect --bootstrap
}

_dockerRESTART() {
set -x
   if [ -d /run/systemd/system ] && command -v systemctl; then
	_sudo systemctl --quiet stop docker || :
	_sudo systemctl start docker
	_sudo systemctl --full --no-pager status docker
   else
	_sudo service docker stop &> /dev/null || :
	_sudo service docker start
   fi
   docker version
}


uid="$(id -u)"
_sudo() {
set -x
	if [ "$uid" = '0' ]; then
		"$@"
	else
    commandVsudo=$(command -v sudo)
    if [ "$commandVsudo" != "" ]; then
    		sudo "$@"
    else
        "$@"
       fi
	fi
}




#BUILDX=$(command -v buildx)
#BUILDX=$(command -v docker-buildx)
#DOCKER_BUILDX_CLI_PLUGIN_PATH=~/.docker/cli-plugins/docker-buildx



_do_dockerClientExperimental() {
#DockerServerVersion=$(docker info --format '{{.ServerVersion}}')
#DockerSexperimental=$(docker info --format '{{.ExperimentalBuild}}')

DockerClientVersion=$(docker version --format '{{.Client.Version}}' 2>/dev/null)
DockerCexperimental=$(docker version --format '{{.Client.Experimental}}' 2>/dev/null)

DockerServerVersion=$(docker version --format '{{.Server.Version}}' 2>/dev/null || docker info --format '{{.ServerVersion}}' 2>/dev/null)
DockerSexperimental=$(docker version --format '{{.Server.Experimental}}' 2>/dev/null || docker info --format '{{.ExperimentalBuild}}' 2>/dev/null)


[ -e $HOME/.docker ] || mkdir -p $HOME/.docker
[ -s $HOME/.docker/config.json ] || echo "{}" > $HOME/.docker/config.json



#SUDO=$(command -v sudo)

# Get the server version
# docker version --format '{{.Server.Version}}'
# Dump raw JSON data
# docker info --format '{{json .}}'
# docker version --format '{{json .}}'
# docker version --format '{{json .}}' | jq


if [[ "$DockerCexperimental" != "true" ]]; then
  # Enable docker cli experimental support (for 'docker build --squash').
  DockerCconfig="$HOME/.docker/config.json"
  if [[ -s "$DockerCconfig" ]]; then
    #sed -i -e 's/{/{ "experimental": true, /' "$DockerCconfig"
cat "$DockerCconfig" | jq '.experimental = "enabled"' >> "$DockerCconfig-tmp"
# see https://stackoverflow.com/questions/44346322/how-to-run-docker-with-experimental-functions-on-ubuntu-16-04
#+#    cat "$DockerCconfig" | jq '.experimental = true' >> "$DockerCconfig-tmp"
    #_sudo sed -i -e 's/{/{ "aliases": { "builder": "buildx" }, /' "$DockerCconfig"
    #sed -i -e 's/{/{ "aliases": [ "builder": "buildx" ],\n/' "$DockerCconfig"
    #cat "$DockerCconfig" | jq -M -S | sed -e 's/^{/{ "aliases": { "builder": "buildx" } ,\n/1' | jq -M -S >
#    cat "$DockerCconfig" | jq -M | sed -e 's/^{/{ "aliases": { "builder": "buildx" } ,\n/1' | jq -M >> $DockerCconfig-tmp
     cat "$DockerCconfig-tmp" | jq '.aliases .builder = "buildx"' > $DockerCconfig-tmp2 && mv $DockerCconfig-tmp2 $DockerCconfig-tmp
#cat $DockerCconfig-tmp | jq --arg aliases builder
    cp -p "$DockerCconfig" "$DockerCconfig-bakup-$(date +%Y-%m-%dT%H%M%S)" && mv "$DockerCconfig-tmp" "$DockerCconfig" || exit 1;
else
    #echo '{ "experimental": true }' | _sudo tee "$DockerCconfig"
    echo {} | tee "$DockerCconfig"
echo {} | jq '.experimental = "enabled"' >> "$DockerSconfigTMP"
#+# echo {} | jq '.experimental = true' >> "$DockerSconfigTMP"
       #_sudo touch "$DockerCconfig"
    cat "$DockerCconfig-tmp" | jq '.aliases .builder = "buildx"' > $DockerCconfig-tmp2 && mv $DockerCconfig-tmp2 $DockerCconfig-tmp
    cp -p "$DockerCconfig" "$DockerCconfig-bakup-$(date +%Y-%m-%dT%H%M%S)" && mv "$DockerCconfig-tmp" "$DockerCconfig" || exit 1;
  fi
  #_dockerRESTART
  #$SUDO systemctl restart docker
fi
}


_do_dockerServerExperimental() {
DockerClientVersion=$(docker version --format '{{.Client.Version}}' 2>/dev/null)
DockerCexperimental=$(docker version --format '{{.Client.Experimental}}' 2>/dev/null)

DockerServerVersion=$(docker version --format '{{.Server.Version}}' 2>/dev/null || docker info --format '{{.ServerVersion}}' 2>/dev/null)
DockerSexperimental=$(docker version --format '{{.Server.Experimental}}' 2>/dev/null || docker info --format '{{.ExperimentalBuild}}' 2>/dev/null)

_sudo sh -xec '
	[ -e /etc/docker ] || mkdir -p /etc/docker
	[ -s /etc/docker/daemon.json ] || echo "{}" > /etc/docker/daemon.json
'

DockerSconfigTMP="/tmp/daemon.json-tmp"
# echo '{"registry-mirrors": [ "http://10.16.1.163:5000" ], "max-concurrent-downloads": 5, "hosts" : ["tcp://0.0.0.0:2375", "unix:///var/run/docker.sock"]}' >> $DockerSconfigTMP
if [[ "$DockerSexperimental" != "true" ]]; then
  # Enable docker daemon experimental support (for 'docker build --squash').
  DockerSconfig='/etc/docker/daemon.json'
  if [[ -s "$DockerSconfig" ]]; then
    #_sudo sed -i -e 's/{/{\n"experimental": true,\n/' "$DockerSconfig"
    _sudo cat "$DockerSconfig" | jq '.experimental = true' >> "$DockerSconfigTMP"
    _sudo cp -p "$DockerSconfig" "$DockerSconfig-bakup-$(date +%Y-%m-%dT%H%M%S)" && _sudo mv "$DockerSconfigTMP" "$DockerSconfig" || exit 1;
  else
    _sudo echo {} | tee "$DockerSconfig"
    #_sudo echo {} | jq '.experimental = true' >> "$DockerSconfigTMP"
    _sudo cat "$DockerSconfig" | jq '.experimental = true' >> "$DockerSconfigTMP"
    _sudo cp -p "$DockerSconfig" "$DockerSconfig-bakup-$(date +%Y-%m-%dT%H%M%S)" && _sudo mv "$DockerSconfigTMP" "$DockerSconfig" || exit 1;
    #echo '{ "experimental": true }' | $SUDO tee "$DockerSconfig"
  fi
  _dockerRESTART
   # $SUDO systemctl restart docker
fi
}


# MAIN
install_docker_buildx
###_do_dockerClientExperimental
# FIXME# 
###_do_dockerServerExperimental

#docker 


} # this ensures the entire script is downloaded #
