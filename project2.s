# my ID 02856440 = 29
# N = 26 + (29 % 11)
#   = 26 + 7 = 33
# base value = 33


	.data

    str: .space 1000


	.text


main:

la $s0, str #load value of string into register $s0

#READ STRING
li $v0, 8 #read string
la $a0, str #load address of string into register $a0
li $a1, 11 #length of expected input including null char
syscall

move $t0, $zero #initializes register $t0 as the index counter

lb $s2, 0($s0) #load char value in register $s0 and put it in $s2

li $v0, 11 #print char value
move $a0, $s2
syscall
