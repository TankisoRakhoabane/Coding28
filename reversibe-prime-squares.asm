#*******************************************
#@author: Tankiso Rakhoabane              * 
#@purpose: reverse-prime-squares          *
#@date: 6 October 2022                    *
#@contact: tartorakhoabane@gmail.com      *
#******************************************

.data
num: .word 1  
divisor: .word 1 
fact_num:	.word 0
reverse: .word 0  	
numbers_to_print: .word 0
msg1: .asciiz "THE FIRST 10 REVERSIBLE PRIME SQUARES: "
deco: .asciiz "****************************************"
newline: .asciiz "\n"
.text
.globl main

main:
#***************************************************************************************************************************************************************************************************************************************************************************************************
#Register mapping
#$t0:square_num
#$t1:num
#$t2:fact_num
#$t3:i
#$t4:divisor
#$t5:rem
#**************************************************************************************************************************************************************************************************************************************************************************************

lw $t1 , num		# number to be checked if its a prime	 
lw $t2 , fact_num 					# number of factors
lw $t3, numbers_to_print 		# number of revervisible prime square printed
lw $t4 , divisor			#divides the numbers	

li $v0, 4
la $a0, deco
syscall

#Print the new line
li $v0, 4
la $a0, newline
syscall

#Print the msg1
li $v0, 4
la $a0, msg1
syscall

#Print the new line
li $v0, 4
la $a0, newline
syscall

li $v0, 4
la $a0, deco
syscall

#Print the new line
li $v0, 4
la $a0, newline
syscall

#start the loop
loop0:
	ble $t3, 10, exit    #as long as the numbers to be printed are less than 10 continue with the loop 
	j end_program
exit:
    ble $t3, 10, go_if
	j print_results
go_if:
    #call primeNum to check if num is prime
    move $a0, $t1     #save the register $t1 in register $a0 
	li $t2, 0         #initialise the number of factors to 0 
	li $t4, 1         #initialise the divisor to 1
	jal primeNum
	beq $v0, 1, is_prime    #if the num tested is a prime number go to is_prime  
	addi $t1, $t1, 1       #go to the next num
	j loop0      #check the next num if its prime
	
is_prime:
    mul $t0, $t1, $t1   #square=num*num

#call reverseNum to reverse the square
    move $a0, $t0
    jal reverseNum
    move $s0, $v0     #move the reversed number to saved register $s0
	
#call checkPalindrome to see the squared number and its reverse are paindromes
    move $a1, $v0	 #move the results of the reverseNum call into the argument $a1
	move $a0, $t0    #move the results of square into argument $a0
	jal checkPalindrome
	beq $v0, 1, is_palindrome    #if the results are true branch to is_palindrome
	j not_true

is_palindrome:
	addi $t1, $t1, 1       #if the square number and it's reverse are palindromes, increment num and go back to the loop
	j loop0
	
not_true:
    #check if the reversed square is a square
	move $a0, $t1
	jal reverseNum     #cal reverseNum to reverse num
	move $s1, $v0         # save the results in register $s1
	move $a0, $v0    #put the results in argument $a0 to go check if the reversed number is a square
	jal primeNum 
	beq $v0,1, Is_prime_number
	addi $t1,$t1, 1
	j loop0
	
Is_prime_number:
	move $a1, $s0
	move $a0, $s1
	jal is_asquare   #call is_asquare to see if the reversed square is a square num
	beq $v0, 1, a_square
j not_asquare
	
#if the reversed square is square print the results
a_square:
    j print_results
	
#if it is not a square increment num and repeat the loop
not_asquare:
    addi $t1, $t1, 1
	j loop0

print_results:
    addi $t3, $t3, 1	
	mul $a0, $t1, $t1
	li $v0, 1
	move $a0, $a0
	syscall
	beq $t3, 10 , end_program		#if 10 numbers have been printed end the program 
	add $t1, $t1,1			# otherwise increment $num to check the other prime numbers
	
	# Skip the line
	li $v0,4
	la $a0, newline
	syscall
	j loop0

	
end_program: 
li $v0, 10
syscall
.end main
#*****************************************************************************************************************************************************************************************************************************************************************************

#function to check if a number is a prime number
primeNum:
	li $t4,1       #initialise the divisor 
	li $t2,0       #initialise the number of factors
loop1:	
    ble $t4, $a0, then        #if the divisor is less or equal to num branch to then
	j if_2                    #if its greator, jump to if_2
    
then:
    rem $t5, $a0, $t4 #temp=num%i
	addi $t4, $t4, 1
    beq $t5, 0, then_if    #if the remainder is equal to 0, branch to then_if
	j loop1
    
then_if:
	addi $t2, $t2, 1       #increment the number of factors
	j loop1

if_2:
    beq $t2, 2, True       #if the number of factors is equal to 2, return True
    j False
True:
	li $a0, 1
	move $v0, $a0
	jr $ra
	
False:
	li $a0, 0
	move $v0, $a0
	jr $ra
.end primeNum
#***********************************************************************************************************************************************************************************************************************************************************

#function to reverse the prime number
reverseNum:
#Initialization of registers
    li $t6, 0      #$t6=reverse
	
loop:
    bne $a0, $zero, end_loop      #if the prime num is not equal to 0, return the its reverse
    j return
end_loop:
    rem $t5, $a0, 10 #remainder=num%10	
	mul $t6, $t6, 10 # reverse=reverse*10
	add $t6, $t6, $t5
	div $a0, $a0, 10 #num=num/10
	j loop	
return:
#return reverse
    move $a1, $t6    #put the rev in $a1
	move $v0, $a1 
	jr $ra	         #return to main
.end reverseNum
#***********************************************************************************************************************************************************************************************************************************

#function to check if the prime num and its reverse are paindromes
checkPalindrome:
    beq $a0, $a1, Then       #if the prime number and its reverse are equal return true
#return False
	li $a0, 0
	move $v0, $a0
	jr $ra
	
Then:
#return True
	li $a0, 1
	move $v0, $a0
	jr $ra
	
.end checkPalindrome
#**********************************************************************************************************************************************************************************************************************************************************

#check if the reversed prime number is a square
is_asquare: 
	divu $t6, $a1, $a0    #divide the reversed prime number by the num 
	
	beq $t6, $a0, asquareNum     #if after division the results is equal to the num then reversed prime num is a square 
	j Not_Square
	
	
asquareNum:
	li $v0, 1
	
	jr $ra

Not_Square:
	li $v0, 0
	jr $ra

.end is_asquare
#*******************************************************************************************************************************************************************************************************************************************************************