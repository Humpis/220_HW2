##############################################################
# Homework #2
# name: Vidar Minkovsky
# sbuid: 109756598
##############################################################
.text

##############################
# PART 1 FUNCTIONS 
##############################

toUpper:
	li $t0, 0 				# String length counter	
	
toUpper_loop:
	lb $t2, 0($a0)				# letter
	beqz $t2, done_toUpper			# hit NULL character at end of string
	blt $t2, 'a', upperAlready		# if it doeant need uppering
	bgt $t2, 'z', upperAlready
	li $t3, 32
	sub $t2, $t2, $t3			# make it upper case by subtracting 32
	sb $t2, 0($a0)
	
upperAlready:
	addi $a0, $a0, 1			# advance to next character of string
	addi $t0, $t0, 1			# counter++
	j toUpper_loop
	
done_toUpper:
	sub $a0, $a0, $t0			# make the starting adress of the string right
	move $v0, $a0
	jr $ra

length2Char:
	li $t0, 0 				# String length counter	
	lb $t1, ($a1)				# letter to stop on
	
length2char_loop:
	lb $t2, 0($a0)				# letter
	beqz $t2, done_length2char		# hit NULL character at end of string
	beq $t2, $t1, done_length2char		# hit the terminating char
	addi $a0, $a0, 1			# advance to next character of string
	addi $t0, $t0, 1			# counter++
	j length2char_loop
	
done_length2char:
	move $v0, $t0
	jr $ra

strcmp:
	li $t0, 0 				# num of same chars
	li $t1, 0 				# equal = false
	li $t2, 0				# length counter
	li $t4, 1				# for subtracting by 1
	blt $a2, 0, strcmp_done			# if length < 0 return 00
	beqz $a2, strcmp_loop0			# if 0, let er rip
	
strcmp_count:
	beqz $a2, strcmp_test			# if str is >= length
	lb $t5 ($a0)
	lb $t6 ($a1)
	beqz $t5, strcmp_done			# hit NULL character at end of string
	beqz $t6, strcmp_done			# hit NULL character at end of string
	addi $t2, $t2, 1			# counter++
	addi $a0, $a0, 1			# advance to next character of string	
	addi $a1, $a1, 1			# advance to next character of string	
	sub $a2, $a2, $t4			# length--
	j strcmp_count	
	
strcmp_test:
	sub $a0, $a0, $t2			# make the starting adress of the string right
	sub $a1, $a1, $t2			# make the starting adress of the string right
	add $a2, $a2, $t2			# make the legnth right

strcmp_loop:
	beqz $a2, strcmp_match			# if all comparisons have been made
	lb $t2, 0($a0)				# letter of str1
	lb $t3, 0($a1)				# letter of str2
	beqz $t2, strcmp_done			# hit NULL character at end of string
	beqz $t3, strcmp_done			# hit NULL character at end of string
	bne $t2, $t3, strcmp_done		# if the letters are !=
	addi $t0, $t0, 1			# samecounter++
	sub $a2, $a2, $t4			# length--
	addi $a0, $a0, 1			# advance to next character of string	
	addi $a1, $a1, 1			# advance to next character of string	
	j strcmp_loop
	
strcmp_loop0:
	lb $t2, 0($a0)				# letter of str1
	lb $t3, 0($a1)				# letter of str2
	beqz $t2, strcmp_done0			# hit NULL character at end of string
	beqz $t3, strcmp_done0			# hit NULL character at end of string
	bne $t2, $t3, strcmp_done		# if the letters are !=
	addi $t0, $t0, 1			# samecounter++
	#sub $a2, $a2, $t4			# length--
	addi $a0, $a0, 1			# advance to next character of string	
	addi $a1, $a1, 1			# advance to next character of string	
	j strcmp_loop0
	
strcmp_done0:
	bnez $t2, strcmp_done			# !hit NULL character at end of string
	bnez $t3, strcmp_done			# !hit NULL character at end of string
	
strcmp_match:
	li $t1, 1				# equal = true

strcmp_done:
	move $v0, $t0
	move $v1, $t1
	jr $ra

##############################
# PART 2 FUNCTIONS
##############################

toMorse:
	li $t0, 0 				# morse characters encoded 
	li $t1, 0 				# sucsessful encoding = false
	#li $t2, 0 				# num chars converted
	blt $a2, 1, toMorse_done		# if size is less than 1
	
toMorse_loop:
	blt $a2, 1, toMorse_done		# out of size, need to put /0
	#blt $a2, $t2, toMorse_done		# last morse seq doesnt fit	actually its probably best to remove the extra chars rather than add parts of it. tbd in the done function
	lb $t3, ($a0)				# charactor of string to be turned into morse
	beqz $t3, toMorse_doneSucsess		# converted all chars
	addi $t4, $t3, -33			# convert ascii to array[i]
	sll $t4, $t4, 2				# t4 = t4*4
	la $t5, MorseCode
	add $t6, $t5, $t4			# t6 = array[i]
	lw $t7, 0($t6)				# word at array[i]
	#save registers and find size of morse code
	addi $sp, $sp, -28			# make space on stack
	sw $t0, 28($sp)				# save registers
	sw $t1, 24($sp)
	sw $t2, 20($sp)
	sw $t7, 16($sp)
	sw $a0, 12($sp)
	sw $a1, 8($sp)
	sw $a2, 4($sp)
	sw $ra, 0($sp)
	la $t7, ($a0)				# function params
	la $a1, length2Char_char
	jal length2Char
	# v0 is length
	lw $t0, 28($sp)				# restore registers
	lw $t1, 24($sp)
	lw $t2, 20($sp)
	lw $t7, 16($sp)
	lw $a0, 12($sp)
	lw $a1, 8($sp)
	lw $a2, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 28			# dealocate space on stack
	
	
	#addi $t2, $t2, 1			# chars converted++
	add $t0, $t0, $v0			# chars converted - length
	sub $a2, $a2, $v0			# size - length
	addi $a0, $a0, 1			# advance to next char in string
	j toMorse_loop
	
toMorse_doneSucsess:
	li $t1, 1				# sucess = true
	
toMorse_done:
	#add /0
	move $v0, $t0
	move $v1, $t1
	jr $ra

createKey:
	#Define your code here
	jr $ra

keyIndex:
	#Define your code here
	jr $ra

FMCEncrypt:
	#Define your code here
	############################################
	# DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
	la $v0, FMorseCipherArray
	############################################
	jr $ra

##############################
# EXTRA CREDIT FUNCTIONS
##############################

FMCDecrypt:
	#Define your code here
	############################################
	# DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
	la $v0, FMorseCipherArray
	############################################
	jr $ra

fromMorse:
	#Define your code here
	jr $ra



.data

MorseCode: .word MorseExclamation, MorseDblQoute, MorseHashtag, Morse$, MorsePercent, MorseAmp, MorseSglQoute, MorseOParen, MorseCParen, MorseStar, MorsePlus, MorseComma, MorseDash, MorsePeriod, MorseFSlash, Morse0, Morse1,  Morse2, Morse3, Morse4, Morse5, Morse6, Morse7, Morse8, Morse9, MorseColon, MorseSemiColon, MorseLT, MorseEQ, MorseGT, MorseQuestion, MorseAt, MorseA, MorseB, MorseC, MorseD, MorseE, MorseF, MorseG, MorseH, MorseI, MorseJ, MorseK, MorseL, MorseM, MorseN, MorseO, MorseP, MorseQ, MorseR, MorseS, MorseT, MorseU, MorseV, MorseW, MorseX, MorseY, MorseZ 

MorseExclamation: .asciiz "-.-.--"
MorseDblQoute: .asciiz ".-..-."
MorseHashtag: .ascii ""
Morse$: .ascii ""
MorsePercent: .ascii ""
MorseAmp: .ascii ""
MorseSglQoute: .asciiz ".----."
MorseOParen: .asciiz "-.--."
MorseCParen: .asciiz "-.--.-"
MorseStar: .ascii ""
MorsePlus: .ascii ""
MorseComma: .asciiz "--..--"
MorseDash: .asciiz "-....-"
MorsePeriod: .asciiz ".-.-.-"
MorseFSlash: .ascii ""
Morse0: .asciiz "-----"
Morse1: .asciiz ".----"
Morse2: .asciiz "..---"
Morse3: .asciiz "...--"
Morse4: .asciiz "....-"
Morse5: .asciiz "....."
Morse6: .asciiz "-...."
Morse7: .asciiz "--..."
Morse8: .asciiz "---.."
Morse9: .asciiz "----."
MorseColon: .asciiz "---..."
MorseSemiColon: .asciiz "-.-.-."
MorseLT: .ascii ""
MorseEQ: .asciiz "-...-"
MorseGT: .ascii ""
MorseQuestion: .asciiz "..--.."
MorseAt: .asciiz ".--.-."
MorseA: .asciiz ".-"
MorseB:	.asciiz "-..."
MorseC:	.asciiz "-.-."
MorseD:	.asciiz "-.."
MorseE:	.asciiz "."
MorseF:	.asciiz "..-."
MorseG:	.asciiz "--."
MorseH:	.asciiz "...."
MorseI:	.asciiz ".."
MorseJ:	.asciiz ".---"
MorseK:	.asciiz "-.-"
MorseL:	.asciiz ".-.."
MorseM:	.asciiz "--"
MorseN: .asciiz "-."
MorseO: .asciiz "---"
MorseP: .asciiz ".--."
MorseQ: .asciiz "--.-"
MorseR: .asciiz ".-."
MorseS: .asciiz "..."
MorseT: .asciiz "-"
MorseU: .asciiz "..-"
MorseV: .asciiz "...-"
MorseW: .asciiz ".--"
MorseX: .asciiz "-..-"
MorseY: .asciiz "-.--"
MorseZ: .asciiz "--.."


FMorseCipherArray: .asciiz ".....-..x.-..--.-x.x..x-.xx-..-.--.x--.-----x-x.-x--xxx..x.-x.xx-.x--x-xxx.xx-"


