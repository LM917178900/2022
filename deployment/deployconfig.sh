
#########################################
### Server Configration
REMOTE_IP="10.122.81.74"
REMOTE_USERNAME="npiadmin"
REMOTE_SERVERNAME="test_npi-app-server"
REMOTE_HOSTNAME="10.122.81.74"
#########################################
### Sgroup Configration
SERVER_TYPE="linux"
APP_TYPE="Other"
APP_NAME="npi-pss-server"
SITE_NAME="npi-pss-server"
DIR_WORK="/data/npi-app/npi/tmp"
DIR_DEPLOY="/data/npi-app/npi/deploy"
DIR_BACKUP="/data/npi-app/npi/backup"

##################required##################
## 是否跳过BACKUP
SKIP_BACKUP=0

## 是否跳过 DEPLOY
SKIP_DEPLOY=0

###################optional#################
# 部署前执行的命令
STEP_BEFORE=""
# 部署完成后执行的命令
STEP_AFTER=""

# 关闭服务的命令
CMD_SHUTDOWN="sudo sh /data/npi-app/npi/deploy/shutdown.sh"

# 启动服务的命令
CMD_STARTUP="sudo sh /data/npi-app/npi/deploy/startup.sh"

# 需要保留的文件，支持多个目录和文件，以空格分隔
KEEPFILE=""

# 不需要备份的文件，采用rsync进行备份，示例：three *.svn *.zip *.tar *.tar.gz
BACKUP_EXCLUDE_FILE=""

#########################################
### Task Configration
APP_PACKAGE="npi-pss-server-upgrade.zip"
#########################################
### Task Detail Configration
DEPLOY_TIME="20220125141018907993"
#########################################
### Deploy Template Configration