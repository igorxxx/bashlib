Bash Lib
=========================


Набор функций для bash скриптов


УСТАНОВКА
------------
Скачать с сайта Github 
```bash
git clone https://github.com/igorxxx/bashlib --depth 1 --branch=master ./
```
Запустить установку 
```bash
cd lib
```
```bash
./install
```

Библиотека backup.lib.sh
-----------
Библиотека для бакапов и синхронизации папок
Подключение
```bash
. /root/lib/backup.lib.sh
```

<span style='color:brown'>**install_backup_lib**</span>
</br>Установка всех необходимых компонентов

Пример:
```bash
install_backup_lib
```

<span style='color:brown;'>**sync_folder** {source} {destination} {exclude file}</span>
</br>Синхронизация папок c файлом списка исключений
- ***$1 {source}*** Папка источник
- ***$2 {destination}*** Папка назначение
- ***$3 {exclude file}*** Файл со списком исключений *(не обязательно)*

Пример:
```bash
sync_folder /root /var/backup/ /root/bin/conf/backup/exclude_root.txt 
```


<span style='color:brown;'>**sync_folder_include** {source} {destination} {exclude file}</span>
</br>Синхронизация папок c файлом списка только включаемых файлов
- ***$1 {source}*** Папка источник
- ***$2 {destination}*** Папка назначение
- ***$3 {exclude file}*** Файл со списком включенных файлов

Пример:
```bash
sync_folder_include /root /var/backup/ /root/bin/conf/backup/include_root.txt 
```


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
