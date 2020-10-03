#!/usr/bin/env bash

# from https://www.depesz.com/2019/03/04/visual-sleep-in-shell-and-shell_utils-repo-information/
# see https://gitlab.com/depesz/shell_utils/blob/master/vsleep

# Unofficial Bash Strict Mode
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'
# End of Unofficial Bash Strict Mode

# Helper functions
die() {
    # shellcheck disable=SC2059
    printf -- "$@" >&2
    printf '\n' >&2
    exit 1
}

show_help_and_die() {
    program_name="$( basename "$0" )"
    echo "Syntax:
    ... | ${program_name} SLEEP_TIME [ SLEEP_TIME ... ]

Where SLEEP_TIME is a number optionally suffixed by one of units:

    s - seconds, default
    m - minutes
    h - hours
    d - days

For example:

    ${program_name} 12     # Sleeps for 12 seconds
    ${program_name} 2m     # Sleeps for 2 minutes
    ${program_name} 3h     # Sleeps for 3 hours
    ${program_name} 1d     # Sleeps for 1 day
    ${program_name} 1h 20m # Will sleep for 1 hour, and then for another 20 minutes"

    exit 0
}

# Converts given number of seconds into human readable form, like:
# - 0s
# - 12s
# - 3m 14s
# - 2h 12m 13s
# - 1d 4h 20m 50s
nice_time() {
    local time="${1}"
    local output=""
    local divider
    local suffix

    while read -r divider suffix
    do
        (( "${time}" < "${divider}" )) && continue
        local v=$(( "${time}" / "${divider}" ))
        time=$(( "${time}" - "${divider}" * "${v}" ))
        output="${output} ${v}${suffix}"
    done <<< $'86400\td\n3600\th\n60\tm'

    (( "${time}" > 0 )) && output="${output} ${time}s"

    [[ -n "${output}" ]] || output="0s"

    echo "${output# }"
}

# Returns maximal length that will be needed to represent any time from 0 to
# <given> argument.
nice_time_len() {
    local time="${1}"
    # There could be longer sleeps than this, but I don't really care about
    # formatting them properly. 15 chars should be enough for up to 100 days.
    (( "${time}" >= 900610  )) && echo 15 && return    # 10d 10h 10m 10s
    (( "${time}" >= 123010  )) && echo 14 && return    # 1d 10h 10m 10s
    (( "${time}" >= 90610   )) && echo 13 && return    # 1d 1h 10m 10s
    (( "${time}" >= 90070   )) && echo 12 && return    # 1d 1h 1m 10s
    (( "${time}" >= 36610   )) && echo 11 && return    # 10h 10m 10s
    (( "${time}" >= 4210    )) && echo 10 && return    # 1h 10m 10s
    (( "${time}" >= 3670    )) && echo 9  && return    # 1h 1m 10s
    (( "${time}" >= 3661    )) && echo 8  && return    # 1h 1m 1s
    (( "${time}" >= 610     )) && echo 7  && return    # 10m 10s
    (( "${time}" >= 70      )) && echo 6  && return    # 1m 10s
    (( "${time}" >= 61      )) && echo 5  && return    # 1m 1s
    (( "${time}" >= 10      )) && echo 3  && return    # 10s
    echo 2
}

# Prints single progress line
# Sets global "done" variable to integer 0..100
# if progress shows that we're done - go to next line to avoid breaking
# display for other programs.
show_progress() {
    local start_at="${1}"
    local sleep_time="${2}"
    local format="${3}"
    local full_bar_len="${4}"

    local from_start
    local bar_len
    local now
    now="$( date '+%s.%N' )"

    read -r from_start done_pct bar_len < <(
        awk -v "n=${now}" -v "s=${start_at}" -v "t=${sleep_time}" -v "b=${full_bar_len}" '
            BEGIN {
                from_start = n-s;
                if (from_start < 0) from_start = 0;

                done_pct = sprintf("%3d", from_start * 100 / t);
                if (done_pct > 100) done_pct = 100;

                bar_len = sprintf("%d", b * from_start / t);

                printf "%d\t%d\t%d\n", from_start, done_pct, bar_len
            }
        '
    )

    local from_end=$(( "${sleep_time}" - "${from_start}" ))
    local togo=$(( 100 - "${done_pct}" ))

    if (( "${full_bar_len}" > 0 ))
    then
        local bar
        printf -v bar "%${bar_len}s"

        # shellcheck disable=SC2059
        printf "${format}" "$( nice_time "${from_start}" )" "${done_pct}" "${bar// /=}" "${togo}" "$( nice_time "${from_end}" )"
    else
        # shellcheck disable=SC2059
        printf "${format}" "$( nice_time "${from_start}" )" "${done_pct}" "${togo}" "$( nice_time "${from_end}" )"
    fi

    # shellcheck disable=SC2015
    (( "${done_pct}" == 100 )) && printf '\n' || true
}

# Parse arguments into simple number of seconds
parse_time() {
    local time="${1}"
    local multiplier=1

    if [[ "${time}" =~ ^[1-9][0-9]*$ ]]
    then
        echo "${time}"
    elif [[ "${time}" =~ ^[1-9][0-9]*?[smhd]$ ]]
    then
        case "${time:(-1)}" in
            s) multiplier=1 ;;
            m) multiplier=60 ;;
            h) multiplier=3600 ;;
            d) multiplier=86400 ;;
        esac
        echo "$(( "${time%?}" * "${multiplier}" ))"
    else
        echo ''
    fi
}
# Helper functions

# MAIN PROGRAM

## Parse and validate command line arguments
while getopts 'h?' opt "$@"
do
    case "${opt}" in
        h|?)
            show_help_and_die
            ;;
    esac
done

# Check that there is at least one sleep time
(( $# < 1 )) && die "You didn't provide sleep time?"

# Check if given sleep times are in correct format, convert to array of
# GIVEN_LABEL:NUMBER_OF_SECONDS
sleep_times=( )
for sleep_time in "$@"
do
    parsed="$( parse_time "${sleep_time}" )"
    [[ -n "${parsed}" ]] || die "Don't understand sleep time of: %s" "${sleep_time}"
    sleep_times+=( "${sleep_time}:${parsed}" )
done

# Recalculate length of fields on first call, and on SIGWINCH event
trap 'recalc_lengths=1' SIGWINCH
recalc_lengths=1

## Main sleeping loop
for sleep_spec in "${sleep_times[@]}"
do
    # Unpack sleep specification
    sleep_label="${sleep_spec%%:*}"
    sleep_time="${sleep_spec##*:}"

    # When do we start this sleep
    start_at="$( date '+%s.%N' )"

    # What is the max length that will be needed to represent time done/todo
    time_len="$( nice_time_len "${sleep_time}" )"

    while true
    do
        # (re)Calculate lengths of fields on first run and on SIGWINCH event.
        if (( "${recalc_lengths}" == 1 ))
        then
            tput_columns="$( tput cols )" # number of columns in terminal
            tput_clean_eol="$( tput el )" # magic sequence to clear data to end of line
            # How long can we use progress bar
            progress_len=$(( "${tput_columns}" - "${#sleep_label}" - 2 - "${time_len}" - 1 - 4 - 2 - 2 - 4 - 1 - "${time_len}" - 1 ))

            if (( "${progress_len}" > 0 ))
            then
                progress_format="\\r${sleep_label}: %${time_len}s/%3d%% [%-${progress_len}s] %3d%%/%${time_len}s${tput_clean_eol}"
                tick="$( awk -v "s=${sleep_time}" -v "p=${progress_len}" 'BEGIN {t=s / (p * 2.1 ); if (t>1) t=1; printf "%.2f\n", t }' )"
            else
                progress_len=0
                progress_format="\\r${sleep_label}: %${time_len}s/%3d%% :: %3d%%/%${time_len}s${tput_clean_eol}"
                tick=1
            fi
            recalc_lengths=0
        fi

        export done_pct=0
        show_progress "${start_at}" "${sleep_time}" "${progress_format}" "${progress_len}"
        (( "${done_pct}" == 100 )) && break

        sleep "${tick}"
    done

done

exit 0
# vim: set ft=sh:
