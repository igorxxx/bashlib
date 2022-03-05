#!/bin/bash

#  ver 1.0
#  Библиотека для бакапов и синхронизации папок
#
#  ** Установка всех необходимых компонентов 
#  install_backup_lib
#
#  ** Синхронизация папок
#  sync_folder <source> <destination> <exclude file>
#  $1<source> Папка источник
#  $2<destination> Папка назначение
#  $3<exclude file> Файл с исключениями
#  Пример:
#  sync_folder /root /var/backup/ /root/bin/conf/backup/exclude_root.txt 

#  ** Синхронизация папок по ssh
#  sync_folder_ssh <source> <login@host> <port> <destination> <exclude file>
#  $1<source> Папка источник
#  $2<login@host> Адрес сервера ssh
#  $3<port> Порт сервера ssh
#  $4<destination> Папка назначение
#  $5<exclude file> Файл с исключениями
#  Пример:
#  sync_folder /root /var/backup/ /root/bin/conf/backup/exclude_root.txt

#
#   ** Арихвирование папок
#   pack_folder <source> <folder> <tar arhive> <password>
#   $1<source>		Путь для архивации
#   $2<folder>          Папка для архивации
#   $3<folder>		Сжимаемая папка
#   $4<tar arhive>	Файл архива
#   $5<password>	Пароль для шифрования
#   Пример
#   pack_folder $PATH_BACKUP_FILES myfiles  /root/ myfiles.tgz 1234
#
#    ** Подключение папки WebDav
#    mount_webdav <path> <url>
#    $1<path> - путь монтирования папки
#    $2<url>  - url WebDav папки
#
#    **  Бакап базы mysql
#    mysql_backup <user> <host> <passwd> <base> <filename> 
#    $1<user>
#    $2<host>
#    $3<passwd>
#    $4<base>
#    $5<filename> - sql.gz
#
#    ** Шифрование файла
#    gpg_encode <filename> <password>
#    $1<filename> - Файл для шифрования (заменяется на filename.gpg)
#    $2<passord> - Пароль для шифрования

function gpg_encode {
	echo $2 | gpg --batch --yes --passphrase-fd 0 -c $1
	rm $1
}


function sync_folder {
 [ ${3:- '-' } == '-' ] && local EXC='' || local EXC='--exclude-from '$3
  mkdirp $2
  rsync -azrl $EXC $1 $2 --delete-excluded
}

function sync_folder_include {
  mkdirp $2
  rsync -azrlm $1 $2 --delete-excluded --include-from $3 --exclude '*'
}

function sync_folder_ssh {
 rsync -avz --no-links --stats -e  "ssh -p $3 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --progress $1 $2:$4 --exclude-from $5 --delete-excluded
}

function md5_folder {
  find $1 -type f -print0 |  xargs -0 md5sum |  md5sum | sed -r 's/ .+//'
}

function mkdirp {
   if [ ! -d "$1" ]; then
      echo "Create $1"
      mkdir -p $1
   fi
}


# shellcheck disable=SC2120
function pack_folder {
   mkdirp $3 
   pushd $1
   tar -zcpf $3$4 $2
   if [ "$5" ]; then
      gpg_encode $3$4 $5
   fi
   popd
}

function pack_dir {
  local SOURCE_PATH=$(dirname "$1")
  local SOURSE_DIR=$(basename "$1")
  local ARH_PATH=$(dirname "$2")
  mkdirp $ARH_PATH
  pushd $SOURCE_PATH >/dev/null || return 1
  tar -cpzf $2 $SOURSE_DIR
  if [ "$3" ]; then
      echo "Encode $1"
      gpg_encode $2 $3
  fi
  popd >/dev/null || return 1
}


function mount_webdav {
  mkdirp $1  
  mount -t davfs -o rw $2 $1
}

function umount_webdav {
  umount $1 
}


function install_backup_lib {
 sudo apt install rsync mhddfs davfs2
}

function mysql_backup {
 # local CODEPAGE = "--default-character-set=cp1251"
 local CODEPAGE=${6:-""}
 mysqldump --user=$1 --host=$2 -acnqQ --verbose --single-transaction $CODEPAGE --password=$3 -- $4 | sed "s#^CREATE TABLE#\0 IF NOT EXISTS# ; s#^INSERT INTO#REPLACE INTO#" | gzip -qf9c >  $5
}

function clear_cache_davfs {
  rm -r /var/cache/davfs2/*
}

function gpg_encode {
  echo $2 | gpg --batch --yes --passphrase-fd 0 -c $1
  rm $1
}

function pack_is_change {
# $1 <source>
# $2 <file.md5>
# $3 <path_backup>
# $4 <gpg password>
echo "Check md5 $1"
MD5=$(md5_folder $1)

if [ ! -f $2 ] || [[ $MD5 != $(cat $2) ]]; then
 echo "Pack $1"
 pack_dir $1 $3 $4
fi
echo $MD5 >$2
}

# sync_folder /root /var/backup/ /root/bin/conf/backup/exclude_root.txt

