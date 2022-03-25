#!/bin/bash
#######################################
## @DESC    : 发布工具包
## @VERSION : 1.0
## @AUTHOR  : zhoucq1@lenovo.com
## @FILEIN  : NA
## @FILEOUT : NA
#######################################

#######################################################
# 文件工具
#######################################################

## @DESC : 备份移动数据
## @IN   : 
## @OUT  : 
function mvdata()
{
    data_src=$1
    data_res=$2
    data_bak=$3
    mkdir -p $data_bak
    set +e
    mv $data_res $data_bak/
    set -e
    mv $data_src $data_res
}

function touchDone()
{
    touch $OUTPUT/$1
}

## 支持等待check
function checkDone()
{
_donefile=$OUTPUT/$1
_check_time=1
_wait_time=300
if [ $# -eq 2 ]
then
    _check_time=$2
fi

if [ $# -eq 3 ]
then
    _wait_time=$3
fi
_try_time=0
while [ $_try_time -lt $_check_time ]
do
info "检查依赖Done文件：$_donefile"
if [ -e "$_donefile" ]
then
    info "依赖Done文件存在! path=$_donefile"
    return 0;
fi
_try_time=$((_try_time+1))
if [ $_try_time -lt $_check_time ]
then
sleep $_wait_time
fi
done
error "依赖Done文件不存在! path=$_donefile"
exit 1
}



function get_system_type()
{
    echo `uname -s`
}

function get_chcp()
{
    __CHCP_CNT__=$(/cygdrive/c/Windows/SysWOW64/chcp |iconv -f GBK -t UTF-8 | grep -i "936" | wc -l)
    echo $__CHCP_CNT__
}

## 检查服务状态
## param: 检查类型, start检查启动, stop检查关闭
function check_service()
{
__CHECK_TYPE__=$1
__TCOUNT__=0
__CHECK_RESULT__=0
__RETRY_TIME__=5
__PS_OPTS__="-ef"
__PROC_NAME__="org.apache.catalina.startup.Bootstrap"
if [ "$(get_system_type)" != "Linux" ]
then
    __PS_OPTS__="-efW"
fi
case $APP_TYPE in
    Tomcat)
    __PROC_NAME__="org.apache.catalina.startup.Bootstrap"
    ;;
    IIS)
    __PROC_NAME__="w3wp.exe"
    ;;
    *)
    error "Error app type: $APP_TYPE"
    exit 1
    ;;
esac
while [ $__TCOUNT__ -lt $__RETRY_TIME__ ]
do
    info "Start checking..."
    sleep 3
    ## IIS 使用appcmd来检查site状态
    if [ $APP_TYPE == "IIS" ]
    then
        PS_COUNT=$(/cygdrive/c/Windows/System32/inetsrv/appcmd.exe list site "/site.name:$SITE_NAME" |grep -i "state:Started" |grep -v grep|wc -l)
    else
        PS_COUNT=$(ps $__PS_OPTS__|grep -i "$__PROC_NAME__" |grep -v grep|wc -l)
    fi
    if [ $PS_COUNT -eq 0 -a "$__CHECK_TYPE__" == "stop" ]
    then
        info "Service has stopped!"
        __CHECK_RESULT__=1
        break;
    fi
    if [ $PS_COUNT -ne 0 -a "$__CHECK_TYPE__" == "start" ]
    then
        info "Service has started!"
        __CHECK_RESULT__=1
        break;
    fi
    __TCOUNT__=$((__TCOUNT__+1))
    error "Check service failed! __TCOUNT__=$__TCOUNT__"
done

if [ $__CHECK_RESULT__ -eq 0 -a "$__CHECK_TYPE__" == "stop" ]
then
    error "Check service stop status failed！！！！"
    exit 1
fi
if [ $__CHECK_RESULT__ -eq 0 -a "$__CHECK_TYPE__" == "start" ]
then
    error "Check service start status failed！！！！"
    exit 1
fi
}

## 检查Session Active状态
function get_iis_session_active()
{
    if [ "$HAS_POWERSHELL" != "1" ]
    then
        error "Can not check session active without POWERSHELL!"
        exit 1
    fi
    if [ "$STATE_SERVER" == "1" ]
    then
        _COUNT_STR_="\asp.net\State Server Sessions Active"
    else
        _COUNT_STR_="\asp.net applications(__total__)\sessions active"
    fi
    _TRY_TIMES_=6
    _TRY_COUNT=0
    _TRY_RESULT=0
    _SESS_CNT_=10000
    while [ $_TRY_COUNT -lt $_TRY_TIMES_ ]
    do
        _SESS_CNT_=$(echo -e "\n" | powershell.exe  "Import-Module WebAdministration; \$CurContTemp = Get-Counter -Counter \"${_COUNT_STR_}\";echo \$CurContTemp.CounterSamples[0].CookedValue" | head -n1 | tr -d '\r')
        info "Session Count: $_SESS_CNT_"
        _TRY_COUNT=$((_TRY_COUNT+1))
        if [ "$_SESS_CNT_" == "0" ]
        then
            _TRY_RESULT=1
            break;
        fi
    done
    if [ $_TRY_RESULT -eq 0 ]
    then
        error "检查Session失败，Session数：$_SESS_CNT_"
        exit 1
    fi
}


## @DESC : 启动STEP_BEFORE
function step_before()
{
if [ "$STEP_BEFORE" != "" ]
then
    info "Start STEP_BEFORE: $STEP_BEFORE"
    $STEP_BEFORE
fi
}

## @DESC : 启动STEP_BEFORE_START
function step_before_start()
{
if [ "$STEP_BEFORE_START" != "" ]
then
    info "Start STEP_BEFORE_START: $STEP_BEFORE_START"
    $STEP_BEFORE_START
fi
}

## @DESC : 启动STEP_AFTER
function step_after()
{
if [ "$STEP_AFTER" != "" ]
then
    info "Start STEP_AFTER: $STEP_AFTER"
    $STEP_AFTER
fi
if [ "$HEALTH_CHECK_URL" != "" ]
then
    Health_Check $HEALTH_CHECK_URL 3 15
fi
}

## @DESC : 检查KEEPFILE
function check_keepfile()
{
if [ "$KEEPFILE" != "" ]
then
info "Check KEEPFILE = $KEEPFILE"
for keepfile in $KEEPFILE
do
    info "KEEPFILE: $keepfile"
    if [ ! -e "$DIR_DEPLOY/$APP_NAME/$keepfile" ]
    then
        error "Can not find the keepfile: $DIR_DEPLOY/$APP_NAME/$keepfile"
        exit 1
    fi
done
fi
}

## @DESC : 恢复KEEPFILE
function restore_keepfile()
{
if [ "$KEEPFILE" != "" ]
then
info "Restore keep files"
for keepfile in $KEEPFILE
do
    info "KEEPFILE: $keepfile"
    cp -r $DIR_BACKUP/$keepfile "$DIR_DEPLOY/$APP_NAME/$keepfile"
done
fi
}

## @DESC : 执行关闭服务命令
function exec_shutdown()
{
if [ "$CMD_SHUTDOWN" != "" ]
then
    info "Start to shutdown service, CMD_SHUTDOWN=$CMD_SHUTDOWN"
    $CMD_SHUTDOWN
fi
}

## @DESC : 执行启动服务命令
function exec_startup()
{
if [ "$CMD_STARTUP" != "" ]
then
    info "Start to startup service, CMD_STARTUP=$CMD_STARTUP"
    $CMD_STARTUP
fi
}

## @DESC : 执行Health_Check,HTTP模式
function check_http()
{
  url=$1
  check_times=1
  wait_time=30
  if [ $# -ge 2 ]
  then
    check_times=$2
  fi
  if [ $# -ge 3 ]
  then
    wait_time=$3
  fi
  try_times=0
  while [ $try_times -lt $check_times ]
  do
    info "Check http status"
    set +e
    httpcode=`curl -I -m 10 -o /dev/null -s -w %{http_code} ${url}`
    set -e
    info "HTTP Code is $httpcode"
    if [ $httpcode -lt 399 -a $httpcode -gt 100 ]
    then
       info "http check success!!!"
       return 0
    fi
    try_times=$((try_times+1))
    if [ $try_times -lt $check_times ]
    then
       info "try $try_times times"
       sleep $wait_time
    fi
  done
  error "$url is Error"
  exit 1
}

## @DESC : 判断命令是否存在
function command_exists()
{
    command -v "$@" > /dev/null 2>&1
}


## @DESC : 执行Health_Check
function Health_Check()
{
  url=$1
  check_times=1
  wait_time=30
  if [ $# -ge 2 ]
  then
    check_times=$2
  fi
  if [ $# -ge 3 ]
  then
    wait_time=$3
  fi
  try_times=0
  while [ $try_times -lt $check_times ]
  do
    info "Check http status"
	sleep 10
    set +e
    httpcode=`curl -k -m 10 -o /dev/null -s -w %{http_code} ${url}`
    set -e
    info "Health Check Response Code is $httpcode"
    if [ $httpcode -lt 399 -a $httpcode -gt 100 ]
    then
       info "Health Check success!!!"
       return 0
    fi
    try_times=$((try_times+1))
    if [ $try_times -lt $check_times ]
    then
       info "try $try_times times"
       sleep $wait_time
    fi
  done
  error "$Health Check Error"
  exit 1
}