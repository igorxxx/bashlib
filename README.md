Bash Lib
=========================


Набор функций для bash скриптов


УСТАНОВКА
------------
Скачать с сайта Github
```console
    $git clone https://github.com/igorxxx/bashlib --depth 1 --branch=master ./
```

Library bash utils
Библиотека для бакапов и синхронизации папок

Установка всех необходимых компонентов 
 `install_backup_lib`

 Синхронизация папок
sync_folder <source> <destination> <exclude file>
$1<source> Папка источник
$2<destination> Папка назначение
$3<exclude file> Файл с исключениями
Пример:


  sync_folder /root /var/backup/ /root/bin/conf/backup/exclude_root.txt 



   ** Арихвирование папок
   pack_folder <source> <folder> <tar arhive> <password>
   $1<source>		Путь для архивации
   $2<folder>          Папка для архивации
   $3<folder>		Сжимаемая папка
   $4<tar arhive>	Файл архива
   $5<password>	Пароль для шифрования
   Пример
   pack_folder $PATH_BACKUP_FILES myfiles  /root/ myfiles.tgz 1234

    ** Подключение папки WebDav
    mount_webdav <path> <url>
    $1<path> - путь монтирования папки
    $2<url>  - url WebDav папки

    **  Бакап базы mysql
    mysql_backup <user> <host> <passwd> <base> <filename> 
    $1<user>
    $2<host>
    $3<passwd>
    $4<base>
    $5<filename> - sql.gz

    ** Шифрование файла
    gpg_encode <filename> <password>
    $1<filename> - Файл для шифрования (заменяется на filename.gpg)
    $2<passord> - Пароль для шифрования
