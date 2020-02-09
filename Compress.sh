#!/bin/bash  -xu

if [ $# -lt 1 ]; then
    echo  "Usage: $0 (DiskImage) [WorkFile]"  1>&2
    exit  1
fi

VBoxManage='VBoxManage'
diskFile=$1
workFile=$2

# ファイルフォーマットを変換する。
rm -f  ${workFile}

stdout=$(${VBoxManage}  clonehd              \
    ${diskFile}  ${workFile}        \
     --format vdi)
echo  "${stdout}"
workUUID=$(echo -n ${stdout} | tr -d '\r' | sed -r "s/^.*\. UUID: (.*)$/\1/")

# vdi ファイルを圧縮する。
${VBoxManage}  modifyhd             \
    ${workFile}  --compact

# 元のファイルをバックアップする。
# mv  -v  ${diskFile}  ${diskFile}.old

# 元の vmdk 形式に変換する。
rm -f  ${diskFile}.new
${VBoxManage}  clonehd  \
    ${workFile}  ${diskFile}.new    \
    --format vmdk                   \
    --variant Split2G

# 作業イメージをリストから除外する。
${VBoxManage}  closemedium disk  ${workUUID}
