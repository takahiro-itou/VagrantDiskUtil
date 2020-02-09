#!/bin/bash  -ue

if [ $# -lt 1 ]; then
    echo  "Usage: $0 (DiskImage)"  1>&2
    exit  1
fi

VBoxManage='VBoxManage'
diskImage=$1

# 全ディスクのリストを取得
diskList=$(
${VBoxManage}  list hdds | tr -d '\r' | gawk '
    /^UUID:/ { uuid=$2; }
    /^Location:/ { location=$2;
        print  "# " uuid "\t" location;
    }')

echo  "# Disk List :"  1>&2
echo  "${diskList}"    1>&2

# 目的のファイルを探す。
echo  "# Run Following Commands:"  1>&2
echo  "${diskList}"       \
   |  fgrep ${diskImage}  \
   |  gawk '{ print "VBoxManage closemedium disk " $2; }'
