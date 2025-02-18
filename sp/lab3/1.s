MYCODE SEGMENT 'CODE'
    ASSUME CS:MYCODE, DS:MYCODE
LET  DB 'A'
START:
; Загрузка сегментного регистра данных DS
     PUSH CS
     POP  DS
; Вывод одного символа на экран
     MOV AH, 02
     MOV DL, LET
     INT 21H
; Ожидание завершения программы
	MOV AH, 01H
	INT 021H
; Выход из программы
     MOV AL, 0
     MOV AH, 4CH
     INT 21H
MYCODE ENDS
END START