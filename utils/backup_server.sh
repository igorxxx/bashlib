#!/bin/bash
# Бакап данных на сервере
# Настройки
# /root/bin/conf/backup/exclude_<папка>.txt Исключения для папок
# Справка - Запуск скрипта без ключа

# Путь дл WebDav Папки
WEBDAV_URL1=http://localhost:4080/cloud/remote.php/dav/files/user
# Дополнить файл /etc/davfs2/secrets
# "http://localhost:4080/cloud/remote.php/dav/files/user"        user          "password"

# Путь до папки с архивом в WebDav
WEBDAV_PATH='/mnt/webdav1/backup/'
# Пароль для архива
GPG_PASS='123123'

# Данные для Mysql
MYSQL_USER='root'
MYSQL_PASS='123123'

# Путь до библиотек bash
PATH_LIB=/root/bin/lib
# Путь до файлов исключений
PATH_EXCLUDE=/root/bin/conf/backup
# Путь до бакапов папок
PATH_BACKUP_FILES=/var/backup/files
# Путь до синхронизации с сервером бакапов
PATH_BACKUP_SYNC=/var/backup/sync

# Настройка паролей
# nano /etc/




# Текущая дата
DATA=`date +%F`

# Пути непосредственного монтирования WebDAV(по числу аккаунтов)
WEBDAV_DIR1=/mnt/webdav1/

# Служебные переменные
ROOT_UID=0   # Только пользователь с $UID 0 имеет привилегии root.
E_NOTROOT=67  # Признак отсутствия root-привилегий.

ME=`basename $0`

. "$PATH_LIB/backup.lib.sh"

if [ "$UID" -ne "$ROOT_UID" ]; then
  echo "Для работы сценария требуются права root."
  exit $E_NOTROOT
fi

function mnt_webdav {
   mount_webdav $WEBDAV_DIR1 $WEBDAV_URL1
}

function umnt_webdav {
   umount $WEBDAV_DIR1
}


function sql_backup_base {
  local  PD="$PATH_BACKUP_SYNC/$1"
  local FILENAME=$PD/$1-$DATA.sql.gz
  mkdirp $PD
  mysql_backup $MYSQL_USER localhost $MYSQL_PASS $1  $FILENAME
  gpg_encode $FILENAME $GPG_PASS
}

function sql_backup {
     sql_backup_base 'cashpay'
}

function do_sync {
# $1 - name
# $2 - path
  local DIRNAME=$(dirname "$2")
  echo "Synchroniation $1"
  sync_folder $2 $PATH_BACKUP_FILES/ $PATH_EXCLUDE/exclude_$1.txt
  pack_is_change $PATH_BACKUP_FILES/$1 $PATH_BACKUP_FILES/$1.md5 $PATH_BACKUP_SYNC/$1/$1-$DATA.tgz $GPG_PASS
}

function do_sync_inc {
# $1 - name
# $2 - path
  local DIRNAME=$(dirname "$2")
  echo "Synchroniation $1"
  sync_folder_include $2 $PATH_BACKUP_FILES/$1 $PATH_EXCLUDE/include_$1.txt
  pack_is_change $PATH_BACKUP_FILES/$1 $PATH_BACKUP_FILES/$1.md5 $PATH_BACKUP_SYNC/$1/$1-$DATA.tgz $GPG_PASS
}

function sync_folders {
   mkdir -p $PATH_BACKUP_FILES
   mkdir -p $PATH_BACKUP_SYNC

    do_sync root /root
    do_sync www /var/www
    do_sync_inc www-var /var/www
    do_sync etc /etc
}

function to_cloud {
   rsync -azrl $PATH_BACKUP_SYNC/* $WEBDAV_PATH
   rm -r $PATH_BACKUP_SYNC/*
}

function allaction {
  sync_folders
  sql_backup
  mnt_webdav
  to_cloud
  umnt_webdav
  clear_cache_davfs
}


function print_help() {
  echo ""
  echo "Скрипт бакапа сервера"
  echo
  echo "Использование: $ME options..."
  echo "Параметры:"
  echo " -folder Создать копию папок"
  echo " -m Монтировать директории webdav."
  echo " -u Размонтировать директории."
  echo " -s Резервное копирование."
  echo " -h Справка."
  echo " -install Установка"
  echo
}


function script_install() {
  install_backup_lib
}

if [ $# = 0 ]; then

  print_help

else
  case $1 in
    "-m") mnt_webdav;
       ;;
   "-folder") sync_folders;
	;;
   "-sync") sync_webdav;
       ;;
   "-n") to_cloud;
	;;
   "-sql") sql_backup;
	;;
    "-cloud") to_cloud;
        ;;
     "-all") allaction;
        ;;
    "-u") umount $WEBDAV_DIR1;
       ;;
    "-h") print_help;
       ;;
    "-install") script_install;
	;;
    *) echo "Неверный параметр $1";
       echo "Для вызова справки выполните $ME -h";
       exit 1
       ;;
    esac
fi

