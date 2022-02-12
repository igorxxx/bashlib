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
 [ ${3:- '-' } == '-' ] && EXC='NO' ||EXC='--exclude-from '$3
  rsync -azqrl $EXC $1 $2
  # echo "rsync -azqrl $EXC $1 $2"
}

function mkdirp {
   if [ ! -d "$1" ]; then
      mkdir -p $1
   fi
}

function pack_folder {
   mkdirp $3 
   pushd $1
   tar -zcpf $3$4 $2
   gpg_encode $3$4 $5
   popd
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

# sync_folder /root /var/backup/ /root/bin/conf/backup/exclude_root.txt

