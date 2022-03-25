#!/bin/bash
#######################################
## @DESC    : 时间工具包
## @VERSION : 1.0
## @AUTHOR  : zhoucaiqin@sogou-inc.com
## @FILEIN  : NA
## @FILEOUT : NA
#######################################


_START_TIME=`date +%s`
_PRE_TIME=`date +%s`
_CUR_TIME=`date +%s`
_DAY=0
_HOUR=0
_MINUTE=0
_SECOND=0

## @DESC : 初始化当前时间
## @IN   : 
## @OUT  : 
initTime(){
	_START_TIME=`date +%s`
	_PRE_TIME=`date +%s`
	_CUR_TIME=`date +%s`
	_DAY=0
	_HOUR=0
	_MINUTE=0
	_SECOND=0

	echo "[START TIME]: "`date "+%Y-%m-%d %H:%M:%S"`

}

## @DESC : 设置当前时间
## @IN   : 
## @OUT  : 
setTime(){
	_DAY=$(($1/24/3600))
	_HOUR=$(($1%(24*3600)/3600))
	_MINUTE=$(($1%3600/60))
	_SECOND=$(($1%60))

}

## @DESC : 显示当前设置时间
## @IN   : 
## @OUT  : 
printTime(){
	echo "[TIME]: ${_DAY}d-${_HOUR}h-${_MINUTE}m-${_SECOND}s"
}

## @DESC : 显示统计时间
## @IN   : 
## @OUT  : 
showTime(){
	_CUR_TIME=`date +"%Y-%m-%d %H:%M:%S"`
	echo -n "[CURR]:$_CUR_TIME" 
	_CUR_TIME=`date +%s`
	_BETWEEN=$(($_CUR_TIME-$_PRE_TIME))
	_PRE_TIME=$_CUR_TIME
	setTime $_BETWEEN
	echo -n " [TIME]:${_DAY}d-${_HOUR}h-${_MINUTE}m-${_SECOND}s"
	_BETWEEN=$(($_CUR_TIME-$_START_TIME))
	setTime $_BETWEEN
	echo " [TOTAL]:${_DAY}d-${_HOUR}h-${_MINUTE}m-${_SECOND}s"
}

## @DESC : 显示当前系统时间
## @IN   : 
## @OUT  : 
showCur(){
	_CUR_TIME=`date +"%Y%m%d %H:%M:%S"`
	echo "[CURR TIME]: $_CUR_TIME" 
}




