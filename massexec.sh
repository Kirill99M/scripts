#!/bin/bash

# Проверка наличия аргументов
if [ $# -lt 1 ]; then
  echo "Usage: $0 [--path dirpath] [--mask mask] [--number number] command"
  exit 1
fi

# Параметры по умолчанию
dirpath="."
mask="*"
number=1 # количество ядер CPU по умолчанию
command=""

# Чтение аргументов
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
  --path)
    dirpath="$2"
    shift # переходим к следующему аргументу
    shift # переходим к следующему аргументу
    ;;
  --mask)
    mask="$2"
    shift
    shift
    ;;
  --number)
    number="$2"
    shift
    shift
    ;;
  *)
    command="$1"
    shift
    ;;
  esac
done

# Проверка существования каталога dirpath
if [ ! -d "$dirpath" ]; then
  echo "Directory $dirpath does not exist."
  exit 1
fi

# Проверка существования исполняемого файла command
if ! type "$command" &> /dev/null; then
    echo "Command $command does not exist or is not executable."
    exit 1
fi

# Получение списка файлов для обработки
files_to_process=($(find "$dirpath" -maxdepth 1 -type f -name "$mask"))

# Запуск процессов для обработки файлов
for file in "${files_to_process[@]}"; do
  "$command" "$file" &

  # Проверка количества запущенных процессов
  running_processes=$(jobs -p)
  while [ ${#running_processes[@]} -ge $number ]; do
    wait -n # ожидание завершения одного из процессов
    running_processes=$(jobs -p)
  done
done

# Ожидание завершения оставшихся процессов
wait
