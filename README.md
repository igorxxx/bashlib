Bash Lib
=========================


Набор функций для bash скриптов


УСТАНОВКА
------------
Скачать с сайта Github 
```bash
wget -O - https://github.com/igorxxx/bashlib/tarball/master | tar xz --strip-components=1
```
Запустить установку 
```bash
cd lib && chmod u+x install && ./install
```

Библиотека backup.lib.sh
-----------
Библиотека для бакапов и синхронизации папок
Подключение
```bash
. /root/lib/backup.lib.sh
```

**install_backup_lib**
</br>Установка всех необходимых компонентов

Пример:
```bash
install_backup_lib
```
---
**sync_folder** `{source}` `{destination}` `{exclude file}`
</br>Синхронизация папок c файлом списка исключений
- `$1 {source}` Папка источник
- `$2 {destination}` Папка назначение
- `$3 {exclude file}` Файл со списком исключений *(не обязательно)*

Пример:
```bash
sync_folder /root /var/backup/ /root/bin/conf/backup/exclude_root.txt 
```
---
**sync_folder_include** `{source}` `{destination}` `{include file}`
</br>Синхронизация папок c файлом списка только включаемых файлов
- `$1 {source}` Папка источник
- `$2 {destination}` Папка назначение
- `$3 {include file}` Файл со списком включенных файлов

Пример:
```bash
sync_folder_include /root /var/backup/ /root/bin/conf/backup/include_root.txt 
```
---
**pack_dir** `{source}` `{arhive}` `{gpg}`
</br> Архивирование папки  tar.gz

- `$1 {source}` Папка источник
- `$2 {arhive}` Файл архива
- `$3 {gpg}` Пароль GPG для шифрования *(не обязательно)*
 
Пример:
```bash
pack_dir /var/data  /var/backup/data.tgz password 
```
---
**pack_is_change** `{source}` `{file.md5}` `{archive}` `{gpg}` 
<br> Архивирование папки если изменился хеш md5 

- `$1 <source>` Путь до папки 
- `$2 <file.md5>` Файл с хешем md5 (создается автоматически)
- `$3` {archive} Файл архива
- `$4 {gpg}` Пароль GPG для шифрования *(не обязательно)*

Пример:
```bash
pack_is_change /var/data /var/data/data.md5 /var/backup/data.tgz password 
```

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
