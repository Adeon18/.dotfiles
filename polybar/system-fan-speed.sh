#!/bin/sh

speed=$(sensors | grep fan1 | awk '{print $2; exit}')

if [ $speed != 0 ]; then
    echo "  $speed RPM"
else
   echo "ﴛ"
fi
