# my ID 02856440 = 29
# N = 26 + (29 % 11)
#   = 26 + 7 = 33
# base value = 33


	.data

    str: .space 1000
    
    invalid: .asciiz "Invalid input"

    one: .word 27000
    
    two: .word 900

    three: .word 30

    four: .word 1

	.text


main:

    la $s0, str #load value of string into register $s0

    #READ STRING
    li $v0, 8 #read string
    la $a0, str #load address of string into register $a0
    li $a1, 5 #length of expected input including null char
    syscall

    move $t0, $zero #initializes register $t0 as the index counter
    move $t1, $zero #initializes register $t1 to serve as a boolean operator

next_char:

    addi $t0, $t0, 1 #increments counter by 1

    lb $s2, 0($s0) #load char value in register $s0 and put it in $s2

# li $v0, 11 #print char value
#   move $a0, $s2
#   syscall
    

    bge $s2, 120, check_outside_base_1 #checks if char lies outside of base range
    bge $s2, 97, check_greater_lower #checks if char is >= a
    bge $s2, 88, check_outside_base_2 #checks if char lies outside of base range
    bge $s2, 65, check_greater_upper #checks if char is >= A
    bge $s2, 58, check_outside_base_3 #checks if char lies outside of base range
    bge $s2, 48, check_greater_num #checks if char is >= 0
    bge $s2, 0, check_outside_base_4 #checks if char lies outside of base range

    
    addi $s0, $s0, 1 #increment index by 1
    bge $t0, 6, print_invalid
    ble $t0, 4, next_char #returns to loop1 label if counter in register $s0 != 10
    j exit

adjust_base:

        j print_invalid

#LABELS TO CONDUCT CALCULATIONS FOR EACH CHAR
multiply_char:
    
#beq $t0, 1, first_element
    j next_char

first_element:
    

#LABELS TO CHECK CHARS INSIDE OF BASE RANGE

check_greater_lower:

    bge $s2, 61, multiply_char
    j exit

check_greater_upper:

    bge $s2, 41, multiply_char
    j exit

check_greater_num:
    bge $s2, 30, multiply_char

#LABELS TO CHECK CHARS OUTSIDE OF BASE RANGE

check_outside_base_1:

        ble $s2, 127, adjust_base
        j exit

check_outside_base_2:
    ble $s2, 96, adjust_base
    j exit

check_outside_base_3:
    ble $s2, 64, adjust_base
    j exit

check_outside_base_4:
    ble $s2, 47, adjust_base
    j exit

print_invalid:
    li $v0, 4 #print string
    la $a0, invalid
    syscall

exit:

    li $v0, 10
    syscall
