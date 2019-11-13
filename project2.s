# my ID 02856440 = 29
# N = 26 + (29 % 11)
#   = 26 + 7 = 33
# base value = 33

#register $t0 will serve as a counter to track the loop count
#register $a0 will hold the address of the output message
#register $s0 will serve as a counter to track the string index
#register $s1 will hold the sum of the string
#register $s2 will hold char value that needs to be manipulated in a function

#register $s3 will hold the value of the first element after it's been multiplied
#register $s4 will hold the value of the second element after it's been multiplied
#register $s5 will hold the value of the third element after it's been multiplied
#register $s6 will hold the value of the fourth element after it's been multiplied

#register $t1 will hold the value of the first element before it's been multiplied
#register $t2 will hold the value of the second element before it's been multiplied
#register $t3 will hold the value of the third element before it's been multiplied
#register $t4 will hold the value of the fourth element before it's been multiplied

#register $t5 will hold the value of the second to last element

	.data

    str: .space 1000
    
    invalid: .asciiz "Invalid input"

    one: .word 1
    
    two: .word 33

    three: .word 1089

    four: .word 35937

	.text


main:

    la $s0, str #load value of string into register $s0

    #READ STRING
    li $v0, 8 #read string
    la $a0, str #load address of string into register $a0
    li $a1, 1001 #length of expected input including null char
    syscall

    move $t0, $zero #initializes register $t0 as the index counter
    move $t1, $zero #initializes register $t1 to serve as a boolean operator
    lb $s2, 0($s0) #load char value in register $s0 and put it in $s2

blank_space:

    

    beq $s2, 9, increment_blank #checks if char is a tab character
    beq $s2, 10, increment_blank #checks if char is a newline character
    beq $s2, 32, increment_blank #checks if char is a space character


next_char:
    
    addi $t9, $t9, 1 #increments counter by 1
    addi $t0, $t0, 1 #increments counter by 1

    lb $s2, 0($s0) #load char value in register $s0 and put it in $s2

start:
    
    beq $s2, 9, print_invalid #checks if char is a tab character
    beq $s2, 10, print_invalid #checks if char is a newline character
    beq $s2, 32, print_invalid #checks if char is a space character

    bge $s2, 120, check_outside_base_1 #checks if char lies outside of base range
    bge $s2, 97, check_greater_lower #checks if char is >= a
    bge $s2, 88, check_outside_base_2 #checks if char lies outside of base range
    bge $s2, 65, check_greater_upper #checks if char is >= A
    bge $s2, 58, check_outside_base_3 #checks if char lies outside of base range
    bge $s2, 48, check_greater_num #checks if char is >= 0
    bge $s2, 0, check_outside_base_4 #checks if char lies outside of base range

continue:

    lb $t5, 0($s0) #load char value in register $s0 and put it in $t5
    addi $s0, $s0, 1 #increment index by 1
    ble $t0, 3, next_char #returns to loop1 label if counter in register $s0 != 10
    
    lb $s2, 0($s0) #load char value in register $s0 and put it in $s2
    addi $t0, $t0, 1 #increments counter by 1

    jal check_end #mute this line to revert to working code
    j multiply_char


#CONVERTING HEX TO DECIMAL

adjust_base:

        j print_invalid

adjust_num:

    addi, $s2, $s2, -48 #convert hex value to decimal
    j store_values

adjust_lower:

addi, $s2, $s2, -87 #convert hex value to decimal
j store_values

adjust_upper:

addi, $s2, $s2, -55 #convert hex value to decimal
j store_values


#STORING VALUES IN TEMPORARY REGISTERS


store_values:
    
    beq $t0, 1, store_one
    beq $t0, 2, store_two
    beq $t0, 3, store_three
    beq $t0, 4, store_four

    j continue

store_one:

    move $t4, $s2
    j continue

store_two:
    
    move $t3, $t4
    move $t4, $s2
    j continue

store_three:

    move $t2, $t3
    move $t3, $t4
    move $t4, $s2
    j continue

store_four:
    
    move $t1, $t2
    move $t2, $t3
    move $t3, $t4
    move $t4, $s2
    j continue


#LABELS TO CONDUCT CALCULATIONS FOR EACH CHAR
multiply_char:
    
    ble $t0, 5, void_enter
    
continue_2:

    beq $t0, 2, one_element
    beq $t0, 3, two_elements
    beq $t0, 4, three_elements
    beq $t0, 5, four_elements

    j continue

four_elements:

    lw, $a1, four
    mult $t1, $a1
    mflo $s3
    jal add_char

three_elements:

    lw, $a1, three
    mult $t2, $a1
    mflo $s3
    jal add_char

two_elements:

    lw, $a1, two
    mult $t3, $a1
    mflo $s3
    jal add_char

one_element:
    
    lw, $a1, one
    mult $t4, $a1
    mflo $s3
    jal add_char

    j print_total





#LABELS TO CHECK CHARS INSIDE OF BASE RANGE

check_greater_lower:

    bge $s2, 61, adjust_lower
    j exit

check_greater_upper:

    bge $s2, 41, adjust_upper
    j exit

check_greater_num:
    bge $s2, 30, adjust_num


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

add_char:
    add $s1, $s1, $s3 #adjust total sum of string
    jr $ra


#PRINT STATEMENTS

void_enter:

#beq $s2, 10, continue_2 #checks if char is a newline character
    beq $s2, 10, check_end #checks if char is a newline character #mute this line and unmute above to revert to working code
    beq $s2, 9, check_end
    beq $s2, 32, check_end

    li $v0, 4 #print string
    la $a0, invalid
    syscall
    j exit

print_invalid:

    ble $t0, 4, void_enter

    li $v0, 4 #print string
    la $a0, invalid
    syscall
    j exit

print_total:

    li $v0, 1
    move $a0, $s1
    syscall

exit:

    li $v0, 10
    syscall

increment_blank:
    
    addi $s0, $s0, 1 #increment index by 1
    lb $s2, 0($s0) #load char value in register $s0 and put it in $s2
    j blank_space

check_end:
    
    ble $t0, 5, increment_blank_end

    move $t6, $t5
    lb $t5, 0($s0) #load char value in register $s0 and put it in $t5

    addi $s0, $s0, 1 #increment index by 1
    addi $t9, $t9, 1 #increment index by 1


    beq $t5, 10, check_end
    beq $t5, 9, check_end
    beq $t5, 32, check_end

    bge $t5, 32, print_invalid

    j continue_2


increment_blank_end:

    move $t6, $t5
    lb $t5, 0($s0) #load char value in register $s0 and put it in $t5
    addi $s0, $s0, 1 #increment index by 1
    lb $s2, 0($s0) #load char value in register $s0 and put it in $s2

    jal check_boolean

    beq $s2, 9, increment_blank_end #checks if char is a tab character
    beq $s2, 10, increment_blank_end #checks if char is a newline character
    beq $s2, 32, increment_blank_end #checks if char is a space character

    addi $t9, $t9, 1 #increments counter by 1

    
    bne $s2, 32, check_boolean_continued #checks if char is a space character

    j continue_2


check_boolean:

    bge $t5, 48, increment

    
    jr $ra

check_boolean_continued:

    beq, $s2, 0, continue_2
    bge, $t9, 3, print_invalid
    j continue_2

increment:

    addi $t9, $t9, 1 #increments counter by 1
    j check_boolean_continued
