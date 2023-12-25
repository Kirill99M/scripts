#!/bin/bash

# Проверка наличия аргумента
if [ $# -ne 1 ]; then
  echo "Usage: $0 <directory_path>"
  exit 1
fi

# Проверка, является ли переданный аргумент каталогом
directory=$1
if [ ! -d "$directory" ]; then
  echo "$directory не является каталогом"
  exit 1
fi

declare -A suffix_count # Ассоциативный массив для подсчета суффиксов

# Функция для обработки файлов в каталоге
process_files() {
    local dir="$1"

    # Поиск всех регулярных файлов в заданном каталоге (рекурсивно)
    while IFS= read -r file; do
        # Получаем расширение файла
        filename=$(basename -- "$file")
        if [[ $filename == *.* ]]; then
            suffix=${filename##*.}
        else
            suffix="no suffix"
        fi

        # Увеличиваем счетчик для данного суффикса
        ((suffix_count[$suffix]++))
    done < <(find "$dir" -type f)
}

# Вызываем функцию для обработки файлов в указанном каталоге
process_files "$directory"

# Вывод статистики по суффиксам в порядке убывания
for suffix in "${!suffix_count[@]}"; do
  echo "$suffix: ${suffix_count[$suffix]}"
done | sort -rn -k2
