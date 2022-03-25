#!/bin/bash
#######################################
## @DESC    : 任务配置文件
## @VERSION : 1.0
## @AUTHOR  : zhoucq1@lenovo.com
## @FILEIN  : NA
## @FILEOUT : NA
#######################################

set -u
set -e
### Prepare env
bin="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" 
source $bin/global.sh
source $bin/timeutil.sh
source $bin/log.sh
source $bin/deployconfig.sh
source $bin/common.sh


DATE_CUR=`date -d"0 days ago" +"%Y%m%d"`

### 环境变量配置 ################################
export LANG=zh_CN.UTF-8

### 目录准备 ####################################
BASE_DIR=$bin/../
BIN=$BASE_DIR/bin
SCRIPT=$BASE_DIR/script
DATA=$BASE_DIR/data
INPUT=$BASE_DIR/input/$DEPLOY_TIME
RESULT=$BASE_DIR/result/$DEPLOY_TIME
TMP=$BASE_DIR/tmp/$DEPLOY_TIME
LOG=$BASE_DIR/log/

mkdir -p $INPUT
mkdir -p $RESULT
mkdir -p $TMP
export RESULT DATA TMP

