#!/bin/bash

# Проверка наличия трех аргументов
if [ "$#" -ne 3 ]; then
    echo "Ошибка: Необходимо указать путь к каталогу, старый суффикс и новый суффикс."
    exit 1
fi

directory=$1
old_suffix=$2
new_suffix=$3

# Проверка, является ли первый аргумент каталогом
if [ ! -d "$directory" ]; then
    echo "Ошибка: Первый аргумент не является каталогом."
    exit 1
fi

# Функция для переименования файлов
rename_files() {
    for file in "$1"/*; do
        if [ -d "$file" ]; then
            rename_files "$file"  # Рекурсивный вызов для подкаталогов
        elif [ -f "$file" ]; then
            base=$(basename "$file")
            if [[ $base == *"$old_suffix" ]]; then
                new_base="${base%$old_suffix}$new_suffix"
                mv "$file" "$1/$new_base"
                echo "Файл $base переименован в $new_base"
            fi
        fi
    done
}

# Вызов функции для переименования файлов
rename_files "$directory"