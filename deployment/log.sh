#!/bin/bash
#######################################
## @DESC    : Log工具包
## @VERSION : 1.0
## @AUTHOR  : zhoucaiqin@sogou-inc.com
## @FILEIN  : NA
## @FILEOUT : NA
#######################################

set -e
set -u

##### 报警收件人配置 #############
_MAIL_FROM="auto-deploy@lenovo.com.cn"
## 分号分隔多个联系人
_MAIL_TO="zhoucq1@lenovo.com.cn"
## 邮件标题前缀
_MAIL_SUBJECT_PREFIX="【DEPLOY】"

_SMS_NUMS=""

LOG_BIN="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" 
export ODI_EXT_TOOL=$LOG_BIN/../../tool/ODIExtTool/oditools.jar
#export SERV_IP="`/sbin/ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"|head -n1`"

_LOG_OPT="$@"

## @DESC : 发送报警邮件
## @IN   : 
## @OUT  : 
function sendError()
{
if [ $# -gt 0 ]
then
_MAIN_SUBJECT=$1
_MAIL_TIME=`date +"%Y-%m-%d %H:%M:%S"`
if [ $# -gt 1 ]
then
_MAIL_CONTENT="$2<br/>[OPT:]${_LOG_OPT}<br/><hr/>Time: $_MAIL_TIME"
else
_MAIL_CONTENT="$1<br/>[OPT:]${_LOG_OPT}<br/><hr/>Time: $_MAIL_TIME"
fi
echo "[LOG][SEND ERROR]: $@" >> $LOG_BIN/log.out
echo "$_MAIL_CONTENT" >> $LOG_BIN/log.out
_MAIN_SUBJECT=${_MAIL_SUBJECT_PREFIX}${_MAIN_SUBJECT}
#java -jar $ODI_EXT_TOOL -qmail "$_MAIL_FROM" "$_MAIL_TO" "$_MAIN_SUBJECT" "$_MAIL_CONTENT"
sh /opt/mail/sendmail.sh -f "$_MAIL_FROM" -t "$_MAIL_TO" -s "$_MAIN_SUBJECT" -c "$_MAIL_CONTENT"
else
	echo "Usage: sendError <mail_subject> [mail_content]"
fi
}

## @DESC : 发送报警短信
## @IN   : 
## @OUT  : 
function sendSMS(){
_SMS_CONTENT=$1
#java -jar $ODI_EXT_TOOL/oditools.jar -sms "$_SMS_NUMS" "$_SMS_CONTENT"
sh /opt/monitor/sendsms.sh "$_SMS_CONTENT" "$_SMS_NUMS"
}

## @DESC : 蓝底白字INFO
## @IN   : 
## @OUT  : 
function info()
{
	echo -e "[INFO][$(date +"%Y-%m-%d %H:%M:%S")]:[ $@ ]"
}

## @DESC : 黄底黑字WARNING
## @IN   : 
## @OUT  : 
function warn()
{
	echo -e "[WARN][$(date +"%Y-%m-%d %H:%M:%S")]:[ $@ ]"
}

## @DESC : 红底黄字闪烁ERROR
## @IN   : 
## @OUT  : 
function error()
{
	echo -e "[ERROR][$(date +"%Y-%m-%d %H:%M:%S")]:[ $@ ]"
}

## @DESC : 进度函数
## @IN   : 
## @OUT  : 
function process()
{
	echo -e "PROCESS RATIO: $1"
}

## @DESC : 触发所有错误输出
## @IN   : 
## @OUT  : 
function sendAllError()
{
	error $@
	sendSMS $@
	sendError $@
}

