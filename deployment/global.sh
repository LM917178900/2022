#!/bin/bash
## 全局配置

## 开始自动部署前的操作
STEP_BEFORE=""

## 自动部署结束后的操作
STEP_AFTER=""

## 保留的文件
KEEPFILE=""

## 忽略备份的文件
BACKUP_EXCLUDE_FILE=""

## 关闭服务命令
CMD_SHUTDOWN=""

## 启动服务命令
CMD_STARTUP=""

## 跳过BACKUP
SKIP_BACKUP=0

## 跳过DEPLOY
SKIP_DEPLOY=0

## 健康检查的URL,可以写成HEALTH_CHECK_URL="http://$REMOTE_IP:8080/demo"
HEALTH_CHECK_URL=""
