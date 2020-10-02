#!/bin/bash
#!/bin/sh
set -e
# based on Code generated by godownloader on 2019-06-13T12:03:00Z
#

usage() {
  this=$1
  cat <<EOF
$this: download go binaries for tmate-io/tmate

Usage: $this [-b] bindir [-d] [tag]
  -b sets bindir or installation directory, Defaults to ./bin
  -d turns on debug logging
   [tag] is a tag from
   https://github.com/tmate-io/tmate/releases
   If tag is missing, then the latest will be used.

 based on Code generated Generated by godownloader
  https://github.com/goreleaser/godownloader

EOF
  exit 2
}

parse_args() {
  #BINDIR is ./bin unless set be ENV
  # over-ridden by flag below
  BINDIR=${BINDIR:-./bin}
  while getopts "b:dh?x" arg; do
    case "$arg" in
      b) BINDIR="$OPTARG" ;;
      d) log_set_priority 10 ;;
      h | \?) usage "$0" ;;
      x) set -x ;;
    esac
  done
  shift $((OPTIND - 1))
  TAG=$1
}
# this function wraps all the destructive operations
# if a curl|bash cuts off the end of the script due to
# network, either nothing will happen or will syntax error
# out preventing half-done work
execute() {
  tmpdir=$(mktemp -d)
  log_debug "downloading files into ${tmpdir}"
  http_download "${tmpdir}/${TARBALL}" "${TARBALL_URL}"
#SKIP#  http_download "${tmpdir}/${CHECKSUM}" "${CHECKSUM_URL}"
#SKIP#  hash_sha256_verify "${tmpdir}/${TARBALL}" "${tmpdir}/${CHECKSUM}"
  srcdir="${tmpdir}/${NAME}"
  rm -rf "${srcdir}"
  (cd "${tmpdir}" && untar "${TARBALL}")
  test ! -d "${BINDIR}" && install -d "${BINDIR}"
  for binexe in $BINARIES; do
    if [ "$OS" = "windows" ]; then
      binexe="${binexe}.exe"
    fi
    install "${srcdir}/${binexe}" "${BINDIR}/"
    log_info "installed ${BINDIR}/${binexe}"
  done
  rm -rf "${tmpdir}"
}
get_binaries() {
  case "$PLATFORM" in
    #darwin/amd64) BINARIES="gometalinter gocyclo nakedret misspell gosec golint ineffassign goconst errcheck maligned unconvert dupl structcheck varcheck safesql deadcode lll goimports gotype staticcheck interfacer unparam gochecknoinits gochecknoglobals" ;;
    darwin/amd64) BINARIES="$BINARY" ;;
    darwin/arm64) BINARIES="$BINARY" ;;
    darwin/i386) BINARIES="$BINARY" ;;
    darwin/ppc64le) BINARIES="$BINARY" ;;
    freebsd/amd64) BINARIES="$BINARY" ;;
    freebsd/arm64) BINARIES="$BINARY" ;;
    freebsd/i386) BINARIES="$BINARY" ;;
    freebsd/ppc64le) BINARIES="$BINARY" ;;
    linux/amd64) BINARIES="$BINARY" ;;
    linux/arm64) BINARIES="$BINARY" ;;
    linux/arm64*) BINARIES="$BINARY" ;;
    linux/armv7*) BINARIES="$BINARY" ;;
    linux/armv6*) BINARIES="$BINARY" ;;
    linux/i386) BINARIES="$BINARY" ;;
    linux/ppc64le) BINARIES="$BINARY" ;;
    netbsd/amd64) BINARIES="$BINARY" ;;
    netbsd/arm64) BINARIES="$BINARY" ;;
    netbsd/i386) BINARIES="$BINARY" ;;
    netbsd/ppc64le) BINARIES="$BINARY" ;;
    openbsd/amd64) BINARIES="$BINARY" ;;
    openbsd/arm64) BINARIES="$BINARY" ;;
    openbsd/i386) BINARIES="$BINARY" ;;
    openbsd/ppc64le) BINARIES="$BINARY" ;;
    windows/amd64) BINARIES="$BINARY" ;;
    windows/arm64) BINARIES="$BINARY" ;;
    windows/i386) BINARIES="$BINARY" ;;
    windows/ppc64le) BINARIES="$BINARY" ;;
    *)
      log_crit "platform $PLATFORM is not supported.  Make sure this script is up-to-date and file request at https://github.com/${PREFIX}/issues/new"
      exit 1
      ;;
  esac
}
tag_to_version() {
  if [ -z "${TAG}" ]; then
    log_info "checking GitHub for latest tag"
  else
    log_info "checking GitHub for tag '${TAG}'"
  fi
  REALTAG=$(github_release "$OWNER/$REPO" "${TAG}") && true
  if test -z "$REALTAG"; then
    log_crit "unable to find '${TAG}' - use 'latest' or see https://github.com/${PREFIX}/releases for details"
    exit 1
  fi
  # if version starts with 'v', remove it
  TAG="$REALTAG"
  VERSION=${TAG#v}
}
adjust_format() {
  # change format (tar.gz or zip) based on OS
  case ${OS} in
    windows) FORMAT=zip ;;
  esac
  true
}
adjust_os() {
  # adjust archive name based on OS
  true
}
adjust_arch() {
  # adjust archive name based on ARCH
  true
}

cat /dev/null <<EOF
------------------------------------------------------------------------
https://github.com/client9/shlib - portable posix shell functions
Public domain - http://unlicense.org
https://github.com/client9/shlib/blob/master/LICENSE.md
but credit (and pull requests) appreciated.
------------------------------------------------------------------------
EOF
is_command() {
  command -v "$1" >/dev/null
}
echoerr() {
  echo "$@" 1>&2
}
log_prefix() {
  echo "$0"
}
_logp=6
log_set_priority() {
  _logp="$1"
}
log_priority() {
  if test -z "$1"; then
    echo "$_logp"
    return
  fi
  [ "$1" -le "$_logp" ]
}
log_tag() {
  case $1 in
    0) echo "emerg" ;;
    1) echo "alert" ;;
    2) echo "crit" ;;
    3) echo "err" ;;
    4) echo "warning" ;;
    5) echo "notice" ;;
    6) echo "info" ;;
    7) echo "debug" ;;
    *) echo "$1" ;;
  esac
}
log_debug() {
  log_priority 7 || return 0
  echoerr "$(log_prefix)" "$(log_tag 7)" "$@"
}
log_info() {
  log_priority 6 || return 0
  echoerr "$(log_prefix)" "$(log_tag 6)" "$@"
}
log_err() {
  log_priority 3 || return 0
  echoerr "$(log_prefix)" "$(log_tag 3)" "$@"
}
log_crit() {
  log_priority 2 || return 0
  echoerr "$(log_prefix)" "$(log_tag 2)" "$@"
}
uname_os() {
  os=$(uname -s | tr '[:upper:]' '[:lower:]')
  case "$os" in
    msys_nt) os="windows" ;;
  esac
  echo "$os"
}
uname_arch_tar() {
  arch_tar=$(uname -m)
  case $arch_tar in
    x86_64) arch_tar="amd64" ;;
    x86) arch_tar="i386" ;;
    i686) arch_tar="i386" ;;
    i386) arch_tar="i386" ;;
    aarch64) arch_tar="arm64v8" ;;
    armv5*) arch_tar="arm32v5" ;;
    armv6*) arch_tar="arm32v6" ;;
    armv7*) arch_tar="arm32v7" ;;
  esac
  echo ${arch_tar}
}
uname_arch() {
  arch=$(uname -m)
  case $arch in
    x86_64) arch="amd64" ;;
    x86) arch="386" ;;
    i686) arch="386" ;;
    i386) arch="386" ;;
    aarch64) arch="arm64" ;;
    armv5*) arch="armv5" ;;
    armv6*) arch="armv6" ;;
    armv7*) arch="armv7" ;;
  esac
  echo ${arch}
}
uname_os_check() {
  os=$(uname_os)
  case "$os" in
    darwin) return 0 ;;
    dragonfly) return 0 ;;
    freebsd) return 0 ;;
    linux) return 0 ;;
    android) return 0 ;;
    nacl) return 0 ;;
    netbsd) return 0 ;;
    openbsd) return 0 ;;
    plan9) return 0 ;;
    solaris) return 0 ;;
    windows) return 0 ;;
  esac
  log_crit "uname_os_check '$(uname -s)' got converted to '$os' which is not a GOOS value. Please file bug at https://github.com/client9/shlib"
  return 1
}
uname_arch_check() {
  arch=$(uname_arch)
  case "$arch" in
    386) return 0 ;;
    amd64) return 0 ;;
    arm64) return 0 ;;
    armv5) return 0 ;;
    armv6) return 0 ;;
    armv7) return 0 ;;
    ppc64) return 0 ;;
    ppc64le) return 0 ;;
    mips) return 0 ;;
    mipsle) return 0 ;;
    mips64) return 0 ;;
    mips64le) return 0 ;;
    s390x) return 0 ;;
    amd64p32) return 0 ;;
  esac
  log_crit "uname_arch_check '$(uname -m)' got converted to '$arch' which is not a GOARCH value.  Please file bug report at https://github.com/client9/shlib"
  return 1
}
untar() {
  tarball=$1
  case "${tarball}" in
    *.tar.gz | *.tgz) tar -xzf "${tarball}" ;;
    *.tar.xz | *.txz) tar -xJf "${tarball}" ;;
    *.tar) tar -xf "${tarball}" ;;
    *.zip) unzip "${tarball}" ;;
    *)
      log_err "untar unknown archive format for ${tarball}"
      return 1
      ;;
  esac
}
http_download_curl() {
  local_file=$1
  source_url=$2
  header=$3
  if [ -z "$header" ]; then
    code=$(curl -w '%{http_code}' -sL -o "$local_file" "$source_url")
  else
    code=$(curl -w '%{http_code}' -sL -H "$header" -o "$local_file" "$source_url")
  fi
  if [ "$code" != "200" ]; then
    log_debug "http_download_curl received HTTP status $code"
    return 1
  fi
  return 0
}
http_download_wget() {
  local_file=$1
  source_url=$2
  header=$3
  if [ -z "$header" ]; then
    wget -q -O "$local_file" "$source_url"
  else
    wget -q --header "$header" -O "$local_file" "$source_url"
  fi
}
http_download() {
  log_debug "http_download $2"
  if is_command curl; then
    http_download_curl "$@"
    return
  elif is_command wget; then
    http_download_wget "$@"
    return
  fi
  log_crit "http_download unable to find wget or curl"
  return 1
}
http_copy() {
  tmp=$(mktemp)
  http_download "${tmp}" "$1" "$2" || return 1
  body=$(cat "$tmp")
  rm -f "${tmp}"
  echo "$body"
}
github_release() {
  owner_repo=$1
  version=$2
  test -z "$version" && version="latest"
  giturl="https://github.com/${owner_repo}/releases/${version}"
  json=$(http_copy "$giturl" "Accept:application/json")
  test -z "$json" && return 1
  version=$(echo "$json" | tr -s '\n' ' ' | sed 's/.*"tag_name":"//' | sed 's/".*//')
  test -z "$version" && return 1
  echo "$version"
}
hash_sha256() {
  TARGET=${1:-/dev/stdin}
  if is_command gsha256sum; then
    hash=$(gsha256sum "$TARGET") || return 1
    echo "$hash" | cut -d ' ' -f 1
  elif is_command sha256sum; then
    hash=$(sha256sum "$TARGET") || return 1
    echo "$hash" | cut -d ' ' -f 1
  elif is_command shasum; then
    hash=$(shasum -a 256 "$TARGET" 2>/dev/null) || return 1
    echo "$hash" | cut -d ' ' -f 1
  elif is_command openssl; then
    hash=$(openssl -dst openssl dgst -sha256 "$TARGET") || return 1
    echo "$hash" | cut -d ' ' -f a
  else
    log_crit "hash_sha256 unable to find command to compute sha-256 hash"
    return 1
  fi
}
hash_sha256_verify() {
  TARGET=$1
  checksums=$2
  if [ -z "$checksums" ]; then
    log_err "hash_sha256_verify checksum file not specified in arg2"
    return 1
  fi
  BASENAME=${TARGET##*/}
  want=$(grep "${BASENAME}" "${checksums}" 2>/dev/null | tr '\t' ' ' | cut -d ' ' -f 1)
  if [ -z "$want" ]; then
    log_err "hash_sha256_verify unable to find checksum for '${TARGET}' in '${checksums}'"
    return 1
  fi
  got=$(hash_sha256 "$TARGET")
  if [ "$want" != "$got" ]; then
    log_err "hash_sha256_verify checksum for '$TARGET' did not verify ${want} vs $got"
    return 1
  fi
}
cat /dev/null <<EOF
------------------------------------------------------------------------
End of functions from https://github.com/client9/shlib
------------------------------------------------------------------------
EOF

PROJECT_NAME="tmate"
OWNER="tmate-io"
REPO="tmate"
BINARY=tmate
FORMAT=tar.xz
OS=$(uname_os)
ARCH=$(uname_arch)
ARCH_TAR=$(uname_arch_tar)
PREFIX="$OWNER/$REPO"

# use in logging routines
log_prefix() {
        echo "$PREFIX"
}
PLATFORM="${OS}/${ARCH}"
GITHUB_DOWNLOAD=https://github.com/${OWNER}/${REPO}/releases/download

uname_os_check "$OS"

uname_arch_check "$ARCH"
#uname_arch_tar "$ARCH_TAR"

parse_args "$@"

get_binaries

tag_to_version

adjust_format

adjust_os

adjust_arch

log_info "found version: ${VERSION} for ${TAG}/${OS}/${ARCH}"

#NAME=${BINARY}-${VERSION}-static-${OS}-${ARCH}
NAME=${BINARY}-${VERSION}-static-${OS}-${ARCH_TAR}
TARBALL=${NAME}.${FORMAT}
TARBALL_URL=${GITHUB_DOWNLOAD}/${TAG}/${TARBALL}
CHECKSUM=${TARBALL}.sha256sum
CHECKSUM_URL=${GITHUB_DOWNLOAD}/${TAG}/${CHECKSUM}

execute

  tmpfileCONFIGfile=$(mktemp abc-script.XXXXXX)
  tmpfileCONFIG="-f $tmpfileCONFIGfile"
  #echo "'set -g terminal-overrides \"xterm*:kLFT5=\eOD:kRIT5=\eOC:kUP5=\eOA:kDN5=\eOB:smkx@:rmkx@\"" >> $tmpfileCONFIGfile
  echo 'set -g terminal-overrides "xterm*:kLFT5=\eOD:kRIT5=\eOC:kUP5=\eOA:kDN5=\eOB:smkx@:rmkx@"' >> $tmpfileCONFIGfile
# echo 'set -g terminal-overrides "xterm*:kLFT5=\eOD:kRIT5=\eOC:kUP5=\eOA:kDN5=\eOB:smkx@:rmkx@"' >> ~/.tmate.conf
# echo "source-file ~/.tmux.conf" >> ~/.tmate.conf

execute_auto_setup() {
  tmpdir=$(mktemp -d)
  log_debug "downloading files into ${tmpdir}"
  #http_download "${tmpdir}/${TARBALL}" "${TARBALL_URL}"
#SKIP#  http_download "${tmpdir}/${CHECKSUM}" "${CHECKSUM_URL}"
#SKIP#  hash_sha256_verify "${tmpdir}/${TARBALL}" "${tmpdir}/${CHECKSUM}"
  #srcdir="${tmpdir}/${NAME}"
  #rm -rf "${srcdir}"
  #(cd "${tmpdir}" && untar "${TARBALL}")
  #test ! -d "${BINDIR}" && install -d "${BINDIR}"
  #for binexe in $BINARIES; do
  #  if [ "$OS" = "windows" ]; then
  #    binexe="${binexe}.exe"
  #  fi
  #  install "${srcdir}/${binexe}" "${BINDIR}/"
  #  log_info "installed ${BINDIR}/${binexe}"
  #done
  #rm -rf "${tmpdir}"
  tmpdir2=$(mktemp -d)
  trap "rm -fr $tmpdir2" 0 2 3 15
  tmpfile=$(mktemp $tmpdir2/abc-script.XXXXXX)
  tmpfile2=$(mktemp $tmpdir2/abc-script.XXXXXX)
 # https://unix.stackexchange.com/questions/181937/how-create-a-temporary-file-in-shell-script/181938#181938
 exec 3>"$tmpfile"
 rm "$tmpfile" ||:
TMATEauthorizedkeysfile=$tmpfile2
echo "$TMATEauthorizedkeys" >> $TMATEauthorizedkeysfile


#debugnull
#tmate $tmpfileCONFIG -F -k tmk-jPa7GdgslQuqt4PAOHxQRAyJTe -n testname
##TMPsession=$(echo $TMATEapikey$(date -u +%F%H) | sha256sum | tr -d [:space:]- )
##TMATEsession=${TMATEsession:-$(echo $TMATEapikey$(date -u +%F%H) | sha256sum | tr -d [:space:]- )}

TMATEapikey=${TMATEapikey:-tmk-jPa7GdgslQuqt4PAOHxQRAyJTe}
TMATEsession=${TMATEsession:-$(echo $TMATEapikey$(date -u +%F%H) | sha256sum | cut -b-50 )}
${BINDIR}/tmate $tmpfileCONFIG -k $TMATEapikey -n $TMATEsession || ${BINDIR}/tmate $tmpfileCONFIG -F -k $TMATEapikey -n $TMATEsession
#${BINDIR}/tmate $tmpfileCONFIG -a $TMATEauthorizedkeysfile -k $TMATEapikey -n $TMATEsession

rm -rf "${tmpdir}" ||:
rm -rf "${tmpdir2}" ||:
rm -fr /tmp/*abc-script* /tmp/tmate* ||:
echo foo >&3
}

execute_auto_setup_foreground() {
  PROG=tmate
  PROGtimeout=10
  tmpdir=$(mktemp -d)
  log_debug "downloading files into ${tmpdir}"
  tmpdir2=$(mktemp -d)
  #trap "rm -fr $tmpdir2" 0 2 3 15
  trap '{
    # this block gets called before exit
    rm -fr $tmpdir2
    pgrep -q $PROG && kill -13 $(pgrep $PROG)
   # ps -Aocomm=,pid=,etime= | sed -ne "s/^$PROG  *//p"
   kill $(ps -Aocomm=,pid= | sed -ne "s/^$PROG  *//p") 
   kill -9 $(ps -Aocomm=,pid= | sed -ne "s/^$PROG  *//p")
    }' 0 2 3 15
  tmpfile=$(mktemp $tmpdir2/abc-script.XXXXXX)
  tmpfile2=$(mktemp $tmpdir2/abc-script.XXXXXX)
 # https://unix.stackexchange.com/questions/181937/how-create-a-temporary-file-in-shell-script/181938#181938
 exec 3>"$tmpfile"
 rm "$tmpfile" ||:
TMATEauthorizedkeysfile=$tmpfile2
echo "$TMATEauthorizedkeys" >> $TMATEauthorizedkeysfile

TMATEapikey=${TMATEapikey:-tmk-jPa7GdgslQuqt4PAOHxQRAyJTe}
TMATEsession=${TMATEsession:-$(echo $TMATEapikey$(date -u +%F%H) | sha256sum | cut -b-50 )}

out=(); i=0
while read -r line; do
    i=`expr $i + 1`
    if [ $i -lt 5 ]; then continue; fi # skip the header lines

    out+=("$line")

    # break if no more items will follow (e.g. Flags != 3)
    if [ $(echo $line | cut -d ' ' -f 3) -ne '3' ]; then
        break
    fi
done < <((sleep $PROGtimeout; pgrep -q $PROG && kill -13 $(pgrep $PROG)) & # kill quickly if trapped
		${BINDIR}./tmate $tmpfileCONFIG -k $TMATEapikey -n $TMATEsession )
#            echo "dns-sd -B _rfb._tcp")

# kill dns-sd child process
pgrep -q $PROG && kill -13 $(pgrep $PROG)
${BINDIR}./tmate $tmpfileCONFIG -k $TMATEapikey -n $TMATEsession

rm -rf "${tmpdir}" ||:
rm -rf "${tmpdir2}" ||:
rm -fr /tmp/*abc-script* /tmp/tmate* ||:
echo foo >&3
}


execute_auto_setup_foreground_timeout() {
  PROG=tmate
  PROGtimeout=${PROGtimeout:-6000}
  tmpdir=$(mktemp -d)
  log_debug "downloading files into ${tmpdir}"
  tmpdir2=$(mktemp -d)
  #trap "rm -fr $tmpdir2" 0 2 3 15
  trap '{
    # this block gets called before exit
    rm -fr $tmpdir2
    pgrep $PROG && kill -13 $(pgrep $PROG)
   # ps -Aocomm=,pid=,etime= | sed -ne "s/^$PROG  *//p"
   kill $(ps -Aocomm=,pid= | sed -ne "s/^$PROG  *//p")
   kill -9 $(ps -Aocomm=,pid= | sed -ne "s/^$PROG  *//p")
    }' 0 2 3 15
  tmpfile=$(mktemp $tmpdir2/abc-script.XXXXXX)
  tmpfile2=$(mktemp $tmpdir2/abc-script.XXXXXX)
 # https://unix.stackexchange.com/questions/181937/how-create-a-temporary-file-in-shell-script/181938#181938
 exec 3>"$tmpfile"
 rm "$tmpfile" ||:
TMATEauthorizedkeysfile=$tmpfile2
echo "$TMATEauthorizedkeys" >> $TMATEauthorizedkeysfile

TMATEapikey=${TMATEapikey:-tmk-jPa7GdgslQuqt4PAOHxQRAyJTe}
TMATEsession=${TMATEsession:-$(echo $TMATEapikey$(date -u +%F%H) | sha256sum | cut -b-50 )}

( (sleep $PROGtimeout; pgrep $PROG && kill -13 $(pgrep $PROG)) & # kill quickly if trapped
                ${BINDIR}/tmate $tmpfileCONFIG -F -k $TMATEapikey -n $TMATEsession )
#            echo "dns-sd -B _rfb._tcp")

# kill dns-sd child process
pgrep $PROG && kill -13 $(pgrep $PROG)
${BINDIR}./tmate $tmpfileCONFIG -k $TMATEapikey -n $TMATEsession

rm -rf "${tmpdir}" ||:
rm -rf "${tmpdir2}" ||:
rm -fr /tmp/*abc-script* /tmp/tmate* ||:
echo foo >&3
}



#execute_auto_setup
execute_auto_setup_foreground_timeout

rm -fr /tmp/*abc-script* /tmp/tmate* ||:
