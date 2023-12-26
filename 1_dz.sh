#!/bin/bash

guessed=0
not_guessed=0
total_guesses=0
guessed_numbers=()
attempts=0
RED='\e[0;31m'
GREEN='\e[0;32m'
RESET='\e[0m'

while true; do
  # Генерация случайного числа от 0 до 9
  secret_number=$((RANDOM % 10))

  read -p "Ход $((attempts + 1)). Введите число от 0 до 9 (или 'q' для выхода): " user_input

  # Проверка на выход
  if [[ "$user_input" == "q" ]]; then
    echo "Игра завершена."
    break
  fi

  # Проверка на корректный ввод
  if ! [[ "$user_input" =~ ^[0-9]$ ]]; then
    echo "Ошибка: Введите число от 0 до 9 или 'q' для выхода."
    continue
  fi

  user_input=$((10#$user_input)) # Приведение введенного значения к числу от 0 до 9
  if ((user_input == secret_number)); then
    echo "Поздравляем! Вы угадали число $secret_number!"
    ((guessed++))
    number_string="\033[32m${secret_number}\e[0m"
  else
    echo "К сожалению, число $user_input не является загаданным числом ($secret_number)."
    ((not_guessed++))
    number_string="\033[31m${secret_number}\e[0m"
  fi
  guessed_numbers+=("$number_string")
  ((attempts++))

  # Вывод статистики игры
  total_guesses=$((guessed + not_guessed))
  printf "\nСтатистика игры:"
  echo "Доля угаданных чисел: $((guessed * 100 / total_guesses))%"
  echo "Доля не угаданных чисел: $((not_guessed * 100 / total_guesses))%"

  # Вывод последних 10 чисел с выделением цветом
  len=${#guessed_numbers[@]}
  echo -n "Последние 10 чисел: "
  if ((len < 10)); then
    for i in $(seq 0 9); do
      echo -e -n "${guessed_numbers[$i]} "
    done
  else
    for i in $(seq $((len - 10)) $((len - 1))); do
      echo -e -n "${guessed_numbers[$i]} "
    done
  fi
  echo ""
done
