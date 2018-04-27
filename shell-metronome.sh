#!/bin/bash
# Author: Alex Baranowski
# License: MIT


REQUIRED_COMMANDS='aplay'
TEMPO=120
METRE=4
BASEDIR=$(dirname "$0")
BEAT_FILE="$BASEDIR/beat.wav"
FIRST_BEAT_FILE="$BASEDIR/accent.wav"
LOOP_COUNTER=0
QUIET=false

trap say_bye INT
say_bye(){
    echo "Goodbye Cruel World"
    exit 0
}

check_files(){
    if [ ! -f "$BEAT_FILE" ] ||  [ ! -f "$FIRST_BEAT_FILE" ];then
         echo "Cannot find beat file/s" && exit 1
    fi
}
print_help(){
    echo "Usage: $(basename "$0") [-t|--tempo <num_arg>] [-m|--metre <num_arg>] [-q|--quiet]"
    exit 0
}
print_error(){
    echo "$(basename "$0") $*"
    exit 1
}
check_required_commands(){
    for my_command in $REQUIRED_COMMANDS; do
        hash $my_command 2>/dev/null || { echo "Script require $my_command command! Aborting"; exit 1; }
    done
}
check_numeric(){
    echo "$METRE" | grep -E -q '^[0-9]+$' || (echo "Metre have to be positiveinteger" && exit 1)
    echo "$TEMPO" | grep -E -q '^[0-9]+$' || (echo "TEMPO is not Integer" && exit 1)
}

parse_config(){
    return
}

play_accent(){
    $QUIET || echo &
    aplay -q "$FIRST_BEAT_FILE" &
    $QUIET || echo -n "* " &
    sleep "$WAIT_TIME"
}
play_beat(){
    aplay -q "$BEAT_FILE" &
    $QUIET || echo -n "* " &
    sleep "$WAIT_TIME"
}


check_required_commands
check_files

while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
        -q|--quiet)
            QUIET=true
            shift
            ;;
        -t|--tempo)
            TEMPO="$2"
            shift
            shift
            ;;
        -m|--metre)
            METRE="$2"
            shift # past argument
            shift # past value
            ;;
        -h|--help)
            print_help
            ;;
        *)    # unknown option
            print_error "$1 arg cannot be parsed"
            ;;
    esac
done
check_numeric
echo "$(basename "$0") - Tempo: $TEMPO, METRE: $METRE/4, kill it with ^C or kill -9 $$"
$QUIET && echo "Quiet mode - won't print beats"
WAIT_TIME=$(bc -l <<< 60/"$TEMPO")
while true; do
    if [[ $((LOOP_COUNTER % METRE)) -eq 0 ]];then
        play_accent
    else
        play_beat
    fi
    LOOP_COUNTER=$((LOOP_COUNTER+1))
done

