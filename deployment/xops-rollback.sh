#!/bin/bash
##############################################################
# Author: zhoucq1
# Date: 2015/11/17
# Desc: CUSTOMIZE ZIP包应用回滚
##############################################################

set -e
set -u
bin="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" 
source $bin/jobconfig.sh

DIR_BACKUP=$DIR_BACKUP/$APP_NAME/$DEPLOY_TIME

step_before

cd "$DIR_DEPLOY"
##############################################################
info "Start to check backup package"
if [ $(ls -A "$DIR_BACKUP" | wc -l 2> /dev/null) -lt 2 ]
then
    error "Can not find the backup file(s) in the directory $DIR_BACKUP"
    exit 1
fi

##############################################################
exec_shutdown
process 20

##############################################################
if [ $SKIP_DEPLOY -ne 1 ]
then
info "Start to deploy the site"
cp -r "$DIR_BACKUP/." "$DIR_DEPLOY/$APP_NAME/"
fi
process 50

##############################################################
exec_startup
process 90

step_after

info "Clean temp directory"
rm -rf $TMP

info "=========================================="
info "*     Rollback Successfully！(-_-)       *"
info "=========================================="
process 100
