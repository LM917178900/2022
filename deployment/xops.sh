#!/bin/bash
##############################################################
# Author: zhoucq1
# Date: 2015/04/28
# Desc: CUSTOMIZE ZIP包应用发布
##############################################################

#  如果有任意一个命令返回了非0就退出
set -e
# 未赋值的变量会认为是错误，并且会向stderr写一个错误
set -u
# ${BASH_SOURCE[0]} 提取脚本的第一个参数，第一个参数是bash,那自动转化为第二个参数，表示脚本本身
#  $( dirname "${BASH_SOURCE[0]}" ) 提取脚本所在目录
# cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd 进入脚本所在目录，并输出路径
# 将脚本路径赋值给 bin 变量
bin="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# 执行bin目录下的jobconfig.sh，而不需要有"执行权限"
source $bin/jobconfig.sh

DIR_BACKUP=$DIR_BACKUP/$APP_NAME/$DEPLOY_TIME

step_before

cd "$DIR_DEPLOY"
##############################################################
check_keepfile
process 5

##############################################################
info "Start to unzip&check the package"
rm -rf $TMP
mkdir -p $TMP
python $bin/unzip.py $DATA/$APP_PACKAGE $TMP
DIR_COUNT=$(ls "$TMP/" | wc -l)
if [ ! -d "$TMP/$APP_NAME" -o $DIR_COUNT -ne 1 ]
then
    error "Zip file is not correct! Please check the zip file"
    ls $TMP
    exit 1
fi

process 10

##############################################################
if [ $SKIP_BACKUP -ne 1 ]
then

info "Start to backup site"
mkdir -p $DIR_BACKUP
echo "$BACKUP_EXCLUDE_FILE" | awk -F' ' '{
for(i=1;i<=NF;i++){if($i!="")print $i;}
}' > $TMP/exclude.txt

info "Exclude file list"
cat $TMP/exclude.txt

if [ -d "$DIR_DEPLOY/$APP_NAME/" ]
then
	if [ "${SERVER_TYPE}" != "linux" ]
	then
		cp -r $DIR_DEPLOY/$APP_NAME/  $DIR_BACKUP/
	else
		rsync -a --no-t --exclude-from "${TMP}/exclude.txt" $DIR_DEPLOY/$APP_NAME/  $DIR_BACKUP/
	fi
else
    warn "Skip backup! Can not find the app directory: $DIR_DEPLOY/$APP_NAME/"
fi

fi
process 15

##############################################################
exec_shutdown
process 20

##############################################################
if [ $SKIP_DEPLOY -ne 1 ]
then

info "Start to deploy the site"
mkdir -p "$DIR_DEPLOY/$APP_NAME/"
cp -fr $TMP/$APP_NAME/. "$DIR_DEPLOY/$APP_NAME/"

fi
process 50

##############################################################
restore_keepfile
process 70

##############################################################
exec_startup
process 90

step_after

info "Clean temp directory"
rm -rf $TMP

info "=========================================="
info "*   Deploy Successfully！！！YES! (^_^)   *"
info "=========================================="
process 100
