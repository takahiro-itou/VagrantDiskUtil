#!/bin/bash  -xue

if [ $# -lt 2 ]; then
    echo "Usage: $0 [VM name] [DiskImage]"  1>&2
    exit  1
fi

VBoxManage='VBoxManage'
vmName=$1
diskImage=$2

# 必要なパラメータを取得
vmUUID=$(${VBoxManage}  list  vms | fgrep ${vmName} \
    | awk '{ print $2; }' | sed -r "s/^\{(.*)\}\r?$/\1/")
echo  "Target UUID = ${vmUUID}"

# 既存の仮想ディスクをデタッチ
${VBoxManage}  storageattach ${vmUUID}  \
    --storagectl  "SCSI"                \
    --port    0                         \
    --type    hdd                       \
    --medium  emptydrive

# 新しい仮想ディクスをアタッチ
${VBoxManage}  storageattach ${vmUUID}  \
    --storagectl  "SCSI"     \
    --device  0                         \
    --port    0                         \
    --type    hdd                       \
    --medium  ${diskImage}
