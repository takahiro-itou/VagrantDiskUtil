#!/bin/bash  -xue

if [ $# -lt 1 ]; then
    echo  "Usage: $0 (DiskImage) [WorkFile]"  1>&2
    exit  1
fi

VBoxManage='VBoxManage'
diskFile=$1
workFile=$2

# ファイルフォーマットを変換する。
${VBoxManage}  clonehe              \
    old.${diskFile}  ${workFile}    \
     --format vdi

# vdi ファイルを圧縮する。
${VBoxManage}  modifyhd             \
    ${workFile}  --compact

# 元の vmdk 形式に変換する。
${VBoxManage}  clonehd  \
    ${workFile}  new.${diskFile}    \
    --format vmdk                   \
    --variant Split2G
