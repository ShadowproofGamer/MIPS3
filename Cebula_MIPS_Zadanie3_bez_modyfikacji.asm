.data
 commandsNumberPrompt: .asciiz "Write how much commands do you want to parse (1 - 5):"
 prompt: .asciiz "Write your command:\n"
 indata: .space 20
 error: .asciiz "Wrong command. Try again:\n"
 errorNumber: .asciiz "Wrong input. Try again:\n"
 continue: .asciiz "Do you want to continue?:\n"
 newline: .asciiz "\n"
 
 .text
 main:
 # prompt on how many commands to parse
 la $a0,commandsNumberPrompt
 li $v0,4
 syscall
 # read the input
 li $v0,5
 syscall 
 #checking if not out of range
 blt $v0, 1, tryAgain
 bgt $v0, 5, tryAgain
 #saving to $s0
 move $s0, $v0
 
 load:
 # prompt
 la $a0,prompt
 li $v0,4
 syscall
 # read the input
 la $a0,indata
 la $a1,20
 li $v0,8
 syscall 
 la $t0,($a0) 		# entered string is stored in the $t0 register
 li $t1,0 		# string length
 li $s1,0		# static string length
 li $s2,0		# stack counter
 

 
 counter:
 lb $t7, 0($t0)
 #increasing string length
 addi $t0, $t0, 1
 addi $t1, $t1, 1
 addi $s1, $s1, 1
 #if string is null or special character
 bnez $t7, counter 
 bgt $t7, 31, counter
 #string length correction
 subu $t1, $t1, $s1
 subu $t0, $t0, $s1
 subi $s1, $s1, 2
 lb $t7, 0($t0)
 
 firstCharCheck:
 #checking first char
 ble $t7, 64, wrongdata
 bge $t7, 123, wrongdata
 beq $t7, 74, jCommands
 beq $t7, 65, aCommands
 beq $t7, 78, noopCommand
 beq $t7, 77, multCommand
 j wrongdata

 

 
 jCommands:
 #standard increment
 addi $t0, $t0, 1
 addi $t1, $t1, 1
 #if next char is space jump to "J label" parser
 lb $t7, 0($t0)
 beq $t7, 32, jumpCommand
  #if next char is space jump to "JAL label" parser
 beq $t7, 65, jalCommand
   #if next char is space jump to "JR command" parser
 beq $t7, 82, jrCommand
 j wrongdata
 
 
 aCommands:
 #standard increment
 addi $t0, $t0, 1
 addi $t1, $t1, 1
 lb $t7, 0($t0)
 bne $t7, 68, wrongdata
  #standard increment
 addi $t0, $t0, 1
 addi $t1, $t1, 1
 lb $t7, 0($t0)
 bne $t7, 68, wrongdata
 #standard increment
 addi $t0, $t0, 1
 addi $t1, $t1, 1
 #if next char is space jump to "add command" parser else if char=i jump to addi command
 lb $t7, 0($t0)
 beq $t7, 32, addCommand
 beq $t7, 73, addiCommand
 j wrongdata
 
 
 
 
 addCommand:
 #standard increment
 addi $t0, $t0, 1
 addi $t1, $t1, 1
  #test of $t7
   lb $t7, 0($t0)
la $a0, ($t7)
li $v0, 1
syscall
  # newline
 la $a0,newline
 li $v0,4
 syscall
 #test end
 jal registerCheck
  #standard increment
 addi $t0, $t0, 2
 addi $t1, $t1, 2
  #test of $t7
   lb $t7, 0($t0)
la $a0, ($t7)
li $v0, 1
syscall
  # newline
 la $a0,newline
 li $v0,4
 syscall
 #test end
 jal registerCheck
  #standard increment
 addi $t0, $t0, 2
 addi $t1, $t1, 2
  #test of $t7
   lb $t7, 0($t0)
la $a0, ($t7)
li $v0, 1
syscall
  # newline
 la $a0,newline
 li $v0,4
 syscall
 #test end
 jal registerCheck
 #addi $t0, $t0, 1
 j joinStack

 
 
 
 
 addiCommand:
  #standard increment
 addi $t0, $t0, 2
 addi $t1, $t1, 2
 jal registerCheck
  #standard increment
 addi $t0, $t0, 2
 addi $t1, $t1, 2
 jal registerCheck
   #standard increment
 addi $t0, $t0, 2
 addi $t1, $t1, 2
 jal registerCheck
 #standard increment
 addi $t0, $t0, 1
 addi $t1, $t1, 1
 lb $t7, 0($t0)
  #checking if the string ended
 subi $t0, $t0, 1
 bge $t1, $s1, joinStack
 beqz $t7, joinStack
 #checking if char is a letter
 bgt $t7, 57, wrongdata
 blt $t7, 48, wrongdata
 bnez $t7, addiCommand
 j wrongdata
 
 
 
 
 noopCommand:
 #standard increment
 addi $t0, $t0, 1
 addi $t1, $t1, 1
 #checking if char equal to O
 lb $t7, 0($t0)
 bne $t7, 79, wrongdata
  #standard increment
 addi $t0, $t0, 1
 addi $t1, $t1, 1
 #checking if char equal to O
 lb $t7, 0($t0)
 bne $t7, 79, wrongdata
  #standard increment
 addi $t0, $t0, 1
 addi $t1, $t1, 1
 #checking if char equal to P
 lb $t7, 0($t0)
 bne $t7, 80, wrongdata
   #standard increment
 addi $t0, $t0, 1
 addi $t1, $t1, 1
 #checking if char equal to P
 lb $t7, 0($t0)
 bgt $t7, 32, wrongdata
 j joinStack
 
 
 
 
 multCommand:
  #standard increment
 addi $t0, $t0, 1
 addi $t1, $t1, 1
 #checking if char equal to U
 lb $t7, 0($t0)
 bne $t7, 85, wrongdata
  #standard increment
 addi $t0, $t0, 1
 addi $t1, $t1, 1
 #checking if char equal to L
 lb $t7, 0($t0)
 bne $t7, 76, wrongdata
  #standard increment
 addi $t0, $t0, 1
 addi $t1, $t1, 1
 #checking if char equal to T
 lb $t7, 0($t0)
 bne $t7, 84, wrongdata
  #standard increment
 addi $t0, $t0, 2
 addi $t1, $t1, 2

 jal registerCheck
  #standard increment
 addi $t0, $t0, 2
 addi $t1, $t1, 2
 jal registerCheck
 #addi $t0, $t0, 1
 j joinStack
 
 
 jumpCommand:
 #standard increment
 addi $t0, $t0, 1
 addi $t1, $t1, 1
 #checking if the string ended
 bge $t1, $s1, joinStack
 #checking if char is a letter
 lb $t7, 0($t0)
 bgt $t7, 122, wrongdata
 blt $t7, 97, ifBigLetterJ
 jumpCommandRepeat:
 bnez $t7, jumpCommand
 j wrongdata
 #checking if char is a big letter
 ifBigLetterJ:
 bgt $t7, 90, wrongdata
 blt $t7, 65, wrongdata
 j jumpCommandRepeat
 
 
 
 
 
 jalCommand:
   #standard increment
 addi $t0, $t0, 1
 addi $t1, $t1, 1
 #checking if char equal to L
 lb $t7, 0($t0)
 bne $t7, 76, wrongdata
  #standard increment
 addi $t0, $t0, 1
 addi $t1, $t1, 1
 lb $t7, 0($t0)
 #checking if the string ended
 bge $t1, $s1, joinStack
 bne $t7, 32, wrongdata
   #standard increment
 addi $t0, $t0, 1
 addi $t1, $t1, 1
 #checking if char is a letter
 lb $t7, 0($t0)
 bgt $t7, 122, wrongdata
 blt $t7, 97, ifBigLetterJAL
 jalCommandRepeat:
 bnez $t7, jumpCommand
 j wrongdata
 #checking if char is a big letter
 ifBigLetterJAL:
 bgt $t7, 90, wrongdata
 blt $t7, 65, wrongdata
 j jalCommandRepeat
 
 
 
 
 
 
 jrCommand:
  #standard increment
 addi $t0, $t0, 1
 addi $t1, $t1, 1
  #checking if the string ended
 bge $t1, $s1, joinStack
 lb $t7, 0($t0)
 bne $t7, 32, wrongdata
   #standard increment
 addi $t0, $t0, 1
 addi $t1, $t1, 1
 jal registerCheck
 #checks for additional characters at the end
 addi $t0, $t0, 1
 lb $t7, 0($t0)
 bgt $t7, 32, wrongdata
 subi $t0, $t0, 1
 lb $t7, 0($t0)
 beq $t7, 44, wrongdata
 j joinStack
 
 
 
 
 
 registerCheck:
 #parameter parser: (memory eg. $12 - ok, $31 - not ok)
 #if different than $ dump
 lb $t7, 0($t0)
 bne $t7, 36, wrongdata
  #standard increment
 addi $t0, $t0, 1
 addi $t1, $t1, 1
 #if different than number (1-9) - dump
 lb $t7, 0($t0)
 blt $t7, 49, wrongdata
 bgt $t7, 57, wrongdata
  #standard increment
 addi $t0, $t0, 1
 addi $t1, $t1, 1
 #if special symbol, space, EOL - print to stack
 lb $t7, 0($t0)
 ble $t7, 33, oneLetter
 beq $t7, 44, oneLetter
 j secondLetter
 oneLetter:
 subi $t0, $t0, 1
 lb $t7, 0($t0)
 #if not 8 or 9 - dump
 blt $t7, 56, wrongdata
 addi $t0, $t0, 1
 jr $ra
 secondLetter:
 #if NAN - dump
 bgt $t7, 57, wrongdata
 blt $t7, 48, wrongdata
  #check back
 subi $t0, $t0, 1
 lb $t7, 0($t0)
 #if $2... eg $23
 beq $t7, 50, ifMemoryExceeded
 #if $3... eg.$31
 bgt $t7, 50, wrongdata
 addi $t0, $t0, 2
 jr $ra
 
 ifMemoryExceeded:
 addi $t0, $t0, 1
  lb $t7, 0($t0)
 bgt $t7, 53, wrongdata
 addi $t0, $t0, 1
 jr $ra
 
 
 
 
 
 
  wrongdata:
 # prompt wrong data
 la $a0,error
 li $v0,4
 syscall
 #j load
 #temporary:
 j end
 
 
  joinStack:
 # prompt
 subu $t0, $t0, $s1
 la $a0,($t0)
 li $v0,4
 syscall
 j end
 
 
 tryAgain:
  # prompt wrong input
 la $a0,error
 li $v0,4
 syscall
 j main
 
 
  end:
 #end program
 li $v0,10
 syscall


 deploy:
 addiu $sp, $sp, -4
 





 # ADD $r1, $r2, $r3,
 #ADDI $r1, $r2, wartosc
 #J label
 #NOOP
 #MULT $s, $t
 #JR $r1
 #JAL label
 
 
 
#test of $t7
   lb $t7, 0($t0)
la $a0, ($t7)
li $v0, 1
syscall
  # newline
 la $a0,newline
 li $v0,4
 syscall
 #test end
 
 
 
