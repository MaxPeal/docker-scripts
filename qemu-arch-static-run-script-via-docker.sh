#!/bin/sh
#
# Run docker-compose in a container
#
# This script will attempt to mirror the host paths by using volumes for the
# following paths:
#   * $(pwd)
#   * $(dirname $COMPOSE_FILE) if it's set
#   * $HOME if it's set
#
# You can add additional volumes (or any docker run options) using
# the $COMPOSE_OPTIONS environment variable.
#


###set -e

#set -vx

PROG=$(basename $0)
PROGdir=$(dirname $0)

#VERSION="1.27.4"
#IMAGE="docker/compose:$VERSION"
VERSION="f5.1.0"
#VERSION="d5.1"
IMAGE="aptman/qus:$VERSION"
qemu_dir="/usr/local/bin/qemu/"
qemu_dir_in_image="/qus/bin"
#WORK_DIR=""
#entrypoint="/qus/bin/qemu-aarch64-static"
entrypoint="/qus/bin/$PROG"

############################################################################################
# form https://github.com/barisione/clang-format-hooks/blob/master/git-pre-commit-format#L34-L42
# realpath is not available everywhere.

readlink() {
    if _has_command readlink; then
        _system_readlink "$@"
    else
        _emulated_readlink "$@"
    fi
}

_has_command() {
    hash -- "$1" 2>/dev/null
}

_system_readlink() {
    command readlink "$@"
}

_emulated_readlink() {
    if [ "$1" = -- ]; then
        shift
    fi

    echo "ERROR ERROR command readlink missing!"
	exit 1
}

realpath() {
    if _has_command realpath; then
        _system_realpath "$@"
    else
        _emulated_realpath "$@"
    fi
}

_system_realpath() {
    command readlink "$@"
}

_emulated_realpath() {
    if [ "$1" = -- ]; then
        shift
    fi

    # Python should always be available on macOS.
    # We use sys.stdout.write instead of print so it's compatible with both Python 2 and 3.
    python -c "import sys; import os.path; sys.stdout.write(os.path.realpath('''$1''') + '\\n')"

}


############################################################################################

#set -vx
PROGbasename=$(basename $0)
PROGrealpath=$(realpath $0)
PROGrealpathBASENAME=$(basename $PROGrealpath)
##PROGreadlink=$(readlink $0)
##PROGreadlinkM=$(readlink -m)

#set -vx
#echo $PROGbasename
#echo $PROGrealpath
#echo $PROGrealpathBASENAME
#echo $PROGreadlink
#set +vx

if [ "$PROGbasename" = "$PROGrealpathBASENAME" ]; then
    echo "PROGbasename GLEICH PROGrealpathBASENAME"
	echo "do the setup with $PROGbasename -S"
else
 #   echo "PROGbasename nicht PROGrealpathBASENAME"
 foo=""
fi



if [ "$PROGbasename" = "$PROGrealpathBASENAME" ]; then
    #echo "PROGbasename GLEICH PROGrealpathBASENAME"
# A POSIX variable
OPTIND=1 # Reset in case getopts has been used previously in the shell.
PROG_SETUP=1

while getopts "STr:v:t:d:" opt; do
    case "$opt" in
        S)  PROG_SETUP=$OPTARG
        ;;
        T)  SMOKE_TEST=$OPTARG
        ;;
        r)  REPO=$OPTARG
        ;;
        v)  VERSION=$OPTARG
        ;;
        t)  TAG_VER=$OPTARG
        ;;
        d)  DOCKER_REPO=$OPTARG
        ;;
    esac
done

if [ -z "$VERSION" ]; then
    echo "usage: $0 -v VERSION" 2>&1
    echo "check https://github.com/${REPO}/releases for available versions" 2>&1
    exit 1
fi

shift $((OPTIND-1))

[ "$1" = "--" ] && shift


# WORKING # docker run --rm --privileged -itv /tmp/qemu:/tmp/qemu --entrypoint="" aptman/qus /bin/sh -c 'cp -vp /qus/bin/*arm* /tmp/qemu'
# WORKING # docker run --entrypoint="" --rm aptman/qus /bin/sh -c 'ls -al /qus/*'
# WORKING # docker run --rm -t --entrypoint="" aptman/qus /qus/bin/qemu-aarch64-static --version
# WORKING # docker run --rm -t multiarch/qemu-user-static:x86_64-aarch64 /usr/bin/qemu-aarch64-static --version


if [ -z "$PROG_SETUP" ]; then
#echo "ln -s $PROG qemu-{aarch64,aarch64_be,alpha,armeb,arm,cris,hppa,i386,m68k,microblazeel,microblaze,mips64el,mips64,mipsel,mipsn32el,mipsn32,mips,nios2,or1k,ppc64abi32,ppc64le,ppc64,ppc,riscv32,riscv64,s390x,sh4eb,sh4,sparc32plus,sparc64,sparc,tilegx,x86_64,xtensaeb,xtensa}-static"

to_archs="aarch64 aarch64_be alpha armeb arm cris hppa i386 m68k microblazeel microblaze mips64el mips64 mipsel mipsn32el mipsn32 mips nios2 or1k ppc64abi32 ppc64le ppc64 ppc riscv32 riscv64 s390x sh4eb sh4 sparc32plus sparc64 sparc tilegx x86_64 xtensaeb xtensa"

for to_arch in $to_archs; do
    echo "ln -s $PROG qemu-${to_arch}-static"
    ln -s $PROG qemu-${to_arch}-static
done
fi


if [ -z "$SMOKE_TEST" ]; then
to_archs="aarch64 aarch64_be alpha armeb arm cris hppa i386 m68k microblazeel microblaze mips64el mips64 mipsel mipsn32el mipsn32 mips nios2 or1k ppc64abi32 ppc64le ppc64 ppc riscv32 riscv64 s390x sh4eb sh4 sparc32plus sparc64 sparc tilegx x86_64 xtensaeb xtensa"

for to_arch in $to_archs; do
	echo 
    echo "qemu-${to_arch}-static"
    $PROGdir/qemu-${to_arch}-static
    $PROGdir/qemu-${to_arch}-static --version
done
fi

#


else
###    echo "PROGbasename nicht PROGrealpathBASENAME"


# Setup options for connecting to docker host
if [ -z "$DOCKER_HOST" ]; then
    DOCKER_HOST='unix:///var/run/docker.sock'
fi
if [ -S "${DOCKER_HOST#unix://}" ]; then
    DOCKER_ADDR="-v ${DOCKER_HOST#unix://}:${DOCKER_HOST#unix://} -e DOCKER_HOST"
else
    DOCKER_ADDR="-e DOCKER_HOST -e DOCKER_TLS_VERIFY -e DOCKER_CERT_PATH"
fi


# Setup volume mounts for compose config and context
if [ "$(pwd)" != '/' ]; then
    VOLUMES="-v $(pwd):$(pwd)"
fi
###if [ -n "$COMPOSE_FILE" ]; then
###    COMPOSE_OPTIONS="$COMPOSE_OPTIONS -e COMPOSE_FILE=$COMPOSE_FILE"
###    compose_dir="$(dirname "$COMPOSE_FILE")"
###    # canonicalize dir, do not use realpath or readlink -f
###    # since they are not available in some systems (e.g. macOS).
###    compose_dir="$(cd "$compose_dir" && pwd)"
###fi
###if [ -n "$COMPOSE_PROJECT_NAME" ]; then
###    COMPOSE_OPTIONS="-e COMPOSE_PROJECT_NAME $COMPOSE_OPTIONS"
####fi
# TODO: also check --file argument
#if [ -n "$compose_dir" ]; then
#    VOLUMES="$VOLUMES -v $compose_dir:$compose_dir"
#fi
if [ -n "$qemu_dir" ]; then
    VOLUMES="$VOLUMES -v $qemu_dir:$qemu_dir_in_image"
fi



if [ -n "$HOME" ]; then
    VOLUMES="$VOLUMES -v $HOME:$HOME -e HOME" # Pass in HOME to share docker.config and allow ~/-relative paths to work.
fi

# Only allocate tty if we detect one
if [ -t 0 ] && [ -t 1 ]; then
    DOCKER_RUN_OPTIONS="$DOCKER_RUN_OPTIONS -t"
fi

# Always set -i to support piped and terminal input in run/exec
DOCKER_RUN_OPTIONS="$DOCKER_RUN_OPTIONS -i"


# Handle userns security
if docker info --format '{{json .SecurityOptions}}' 2>/dev/null | grep -q 'name=userns'; then
    DOCKER_RUN_OPTIONS="$DOCKER_RUN_OPTIONS --userns=host"
fi

if [ -n "$WORK_DIR" ]; then
    WORK_DIR_OPTIONS="-w $(WORK_DIR)"
fi


# shellcheck disable=SC2086
#exec docker run --entrypoint="" --rm $DOCKER_RUN_OPTIONS $DOCKER_ADDR $COMPOSE_OPTIONS $VOLUMESfoo -w "$(pwd)" $IMAGE "$@"
if [ -z "$SMOKE_TEST" ]; then
set -x
fi
exec docker run --entrypoint="$entrypoint" --rm $DOCKER_RUN_OPTIONS $DOCKER_ADDR $COMPOSE_OPTIONS $VOLUMESfoo $WORK_DIR_OPTIONS $IMAGE $qemu_dir_in_image/$PROGbasename "$@"
fi
