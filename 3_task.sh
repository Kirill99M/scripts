#!/bin/bash

# Проверка наличия одного аргумента
if [ "$#" -ne 1 ]; then
    echo "Ошибка: Необходимо указать только путь к каталогу."
    exit 1
fi

directory=$1

# Проверка, является ли аргумент каталогом
if [ ! -d "$directory" ]; then
    echo "Ошибка: Аргумент не является каталогом."
    exit 1
fi

# Получаем логин пользователя и текущую дату
user_name=$(whoami)
date=$(date -I)

# Обработка файлов с расширением .txt в указанном каталоге
for file in "$directory"/*.txt; do
    if [ -f "$file" ]; then
        echo "Approved $user_name $date" | cat - "$file" > temp && mv temp "$file"
        echo "Файл $file обработан"
    fi
done