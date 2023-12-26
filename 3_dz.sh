#!/bin/bash

#подготовка игрального поля
init_game(){
	#массив, который будет хранить состояние игры, изначально пустое значение
    M=()
	#пустая ячейка доски, переменная будет хранить индекс элемента, в котором хранится "пустое место"
    EMPTY=
	#заполняем поле фишками случайным образом, находим "пустое место" на поле, записываем номерячейки в переменную EMPTY
    RANDOM=$RANDOM
    for i in {1..15}
    do
        j=$(( RANDOM % 16 ))
        while [[ ${M[j]} != "" ]]
        do
            j=$(( RANDOM % 16 ))
        done
        M[j]=$i
    done
    for i in {0..15}
    do
        [[ ${M[i]} == "" ]] && EMPTY=$i
    done
    #отрисовываем игровое поле
    draw_board
}

#функция для вывода на экран игрового поля
draw_board(){
    clear
    D="-----------------"
    S="%s\n|%3s|%3s|%3s|%3s|\n"
    printf $S $D ${M[0]:-"."} ${M[1]:-"."} ${M[2]:-"."} ${M[3]:-"."}
    printf $S $D ${M[4]:-"."} ${M[5]:-"."} ${M[6]:-"."} ${M[7]:-"."}
    printf $S $D ${M[8]:-"."} ${M[9]:-"."} ${M[10]:-"."} ${M[11]:-"."}
    printf $S $D ${M[12]:-"."} ${M[13]:-"."} ${M[14]:-"."} ${M[15]:-"."}
    echo $D
}

exchange(){
    M[$EMPTY]=${M[$1]}
    M[$1]=""
    EMPTY=$1
}

#Оценка результатов хода
check_win(){
    for i in {0..14}
    do
        if [ "${M[i]}" != "$(( $i + 1 ))" ]
        then
            return
        fi
    done
    echo "Головоломка собрана![y/n]?"
    while :
    do
        read -n 1 -s
        case $REPLY in
            y|Y)
                init_game
                break
            ;;
            n|N) exit
            ;;
        esac
    done
}

#бесконечный цикл, в котором будет приниматься ход игрока
start_game(){
while :
do
    echo "Чтобы сделать ход используйте клавиши w (вверх),a (влево),s (вниз),d (вправо), q - для выхода из игры"
    read -n 1 -s
    case $REPLY in
        w)
            [ $EMPTY -lt 12 ] && exchange $(( $EMPTY + 4 ))
        ;;
        a)
            COL=$(( $EMPTY % 4 ))
            [ $COL -lt 3 ] && exchange $(( $EMPTY + 1 ))
        ;;
        s)
            [ $EMPTY -gt 3 ] && exchange $(( $EMPTY - 4 ))
        ;;
        d)
            COL=$(( $EMPTY % 4 ))
            [ $COL -gt 0 ] && exchange $(( $EMPTY - 1 ))
        ;;
        q)
            quit_game
        ;;
    esac
    draw_board
    check_win
done
}

quit_game(){
    while :
    do
	#Ожидание хода игрока
        read -n 1 -s -p "Хотите выйти?[y/n]?"
        case $REPLY in
            y|Y) exit
            ;;
            n|N) return
            ;;
        esac
    done
}

init_game
start_game