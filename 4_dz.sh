#!/bin/bash
declare -a pids
completed=0
toDo=0

while getopts "d:e:c:n:" option
do
  case $option in
    e ) mask="$OPTARG";;
    d ) dirpath="$OPTARG";;
    c ) command="$OPTARG";;
    n ) number="$OPTARG";;
  esac
done

echoCompleted(){
  echo $completed
}

echoTodo(){
  echo $toDo
}

trap echoCompleted SIGUSR1
trap echoTodo SIGUSR2

get_abs_filename() {
  echo "$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
}

files=($dirpath/$mask)

for file in ${files[*]}
do
  if (( $toDo > $number ))
  then
    wait -n ${pids[*]}
    completed=$((completed + 1))
    toDo=$((toDo - 1))
  fi
    ($command $(get_abs_filename $file);) &
    toDo=$((toDo + 1))
    pids+=($!)
done

while (( $completed != ${#files[@]} ))
do
  wait -n ${pids[*]}
  completed=$((completed + 1))
  toDo=$((toDo - 1))
done