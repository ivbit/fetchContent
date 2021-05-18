#!/bin/ksh

# Intellectual property information START
# 
# Copyright (c) 2021 Ivan Bityutskiy 
# 
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
# 
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
# 
# Intellectual property information END

# Description START
#
# The script fetches data from server,
# filters it and displays it through less.
#
# Description END

# Shell settings START
set -o noglob
# Shell settings END

# Declare variables START
# Data is in UTF-8 format.
export LC_CTYPE='en_US.UTF-8'
# Make less display non-printable UTF-8 characters as '-'.
export LESSCHARSET='utf8'
export LESSBINFMT='-'
export LESSUTFBINFMT='-'
# Variables
typeset userInput=''
typeset coloredInput=''
typeset theURL='https://192.168.1.4/m.exe?l1=1&l2=2&s='
integer counter=0
# Declare variables END

# BEGINNING OF SCRIPT
if (( $# ))
then
  # Process user input
  userInput=$(print -- "$@" | sed 's/ /+/g')
  # Green color
  coloredInput="\033[32m${@}\033[0m\n"
else
  read -- strWords?"Word(s): "
  # Process user input
  userInput=$(print -- "$strWords" | sed 's/ /+/g')
  # Green color
  coloredInput="\033[32m${strWords}\033[0m\n"
fi

# Fetch data, filter junk,
# make every second line blue,
# display through less
curl -s "${theURL}${userInput}" |
grep '<td class="trans"' |
sed -E -e 's///g' -e 's/<p>/\
/' -e 's/<p[^<]+<\/p>//g' -e 's/<!--[^>]+-->//g' -e 's/<i><[^<]+<[^<]+<\/i>; <span STYLE="color:rgb\([^)]+\)">//g' -e 's/<font[^>]+>[^<]+<\/font>//g' -e 's/ <span style="color:gray">\(<i><[^<]+<[^<]+<\/i>\)//g' -e 's/<[^><]+>[^><]+>//g' -e 's/<[^>]+>//g' -e 's/&nbsp;[^)]+//g' -e 's/&#[^;]+; *//g' |
while read -- string
do
  if (( counter++ & 1 ))
  then
    print -- "\033[34m${string}\033[0m"
  else
    print -- "$coloredInput$string"
    coloredInput=''
  fi
done |
  less -R

# Shell settings START
set +o noglob
# Shell settings END

# END OF SCRIPT

