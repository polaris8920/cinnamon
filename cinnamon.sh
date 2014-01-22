#! /bin/sh

# File:      cinnamon.sh
# Author:    polaris8920
# Date:      2014-01-21
# Version:   1.0

# Purpose:
# Execute tests for a program using a set of files which are set to the
# program's stdin.

execProg=""
comment="//"

# Name:        usage
# Purpose:     print the usage statement
# Output:      a command line instruction
# Assumptions: none
# Bugs:        none
usage ()
{
  printf "Usage: cinnamon.sh [-c=<comment marker>] "
  printf "<program file> <test cases> ...\n" 1>&2
}

# Name:        star_pad
# Purpose:     pad a message with stars, for example "Hi becomes:
#  ********
#  ** Hi **
#  ********
# Output:      a message padding with stars
# Assumptions: none
# Bugs:        none
star_pad ()
{
  line=" ** $1 ** "
  length=`echo ${#line} - 2 | bc`
  printf " "
  for c in `seq $length`
  do
    printf "*"
  done
  printf "\n$line\n "
  for c in `seq $length`
  do
    printf "*"
  done
  printf "\n"
}

# pull arguments
while [ "$1" != "" ]; do
  PARAM=`echo $1 | awk -F= '{print $1}'`
  VALUE=`echo $1 | awk -F= '{print $2}'`
  case $PARAM in
    -h | --help | -\?)
      usage
      exit 0
      ;;
    -c | --comment)
      comment="$VALUE"
      shift
      ;;
    --)
      shift
      break
      ;;
    -*)
      echo "ERROR: unknown parameter \"$PARAM\""
      usage
      exit 1
      ;;
    *)
      break
      ;;
    esac
done

# ensure enough file arguments
if [ $# -lt 2 ]
then
  usage
  exit 1
fi

# grab program
fname=$(basename "$1")
ext="${fname##*.}"
fname="${fname%.*}"
shift

# determine how to run program
if [ $ext = "java" ] || [ $ext = "class" ]
then
  execProg="java $fname"
elif [ $ext = "sh" ]
then
  execProg="sh $fname.$ext"
else
  execProg="./$fname"
fi

# execute test cases
for case in "$@"
do
  echo "================================================"
  star_pad "Test case: $case"
  case_fname=$(basename "$case")
  case_ext="${case_fname##*.}"
  case_fname="${case_fname%.*}"
  cat "$case"
  printf "\n"
  star_pad "Output:"

  tmp_in=`mktemp`
  cat $case > $tmp_in
  sed -i "s:$comment.*$::g" $tmp_in

  if [ $case_ext = "in" ] && [ -e "$case_fname.out" ]
  then
    tmp_file=`mktemp`
    eval "$execProg < $tmp_in > $tmp_file 2>&1"
    cat "$tmp_file"
    star_pad "diff stdout $case_fname.out"
    diff "$tmp_file" "$case_fname.out"
    rm $tmp_file
  else
    cat "$case"
    eval "$execProg < $tmp_in"
  fi
  rm $tmp_in
  echo "================================================"
  printf "\n\n"
done
