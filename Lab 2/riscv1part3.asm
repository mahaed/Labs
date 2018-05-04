 #Lab 2 Part 3
#Mahaed Mohamud & Sean Wright
#ECEGR 2220 
#4/

	.data # Data declaration section
Z:	.word  2
I:	.word

	.text #Readable only section include executable code
main:
	la x1, Z #Load Z
	la x2, I #Load I
	lw x28, 0(x1)  #Just for use of math with Z.
	lw x29, 0(x2)  #Just use I for the logical increment check w/ a for loop and while loop as well.
	
	li x5, 20 #The maximum number that it can only increments up by two every time it execute the loop.
	li x6, 99 # The number for the while loop that can be passed and accepted from 2 to 99.
	li x7, 1 #The mininmum accepted number for the last while loop to be passed before it cease. 
	slt x16, x29, x5 #If value of i is less than 20, then x16 = 1. Else, its false and x16 = 0
	bne x16, x0, loop
	
loop:
	addi x28, x28,	1 
	addi x29, x29,  2 #Increments by two every time until it reachs 20. 
	beq  x29, x5, do #If I = 20 then directly go to the do while loop. 
	j loop
	
do: 
    beq x28, x6, while #Check if Z is equal to 99 because it will continously increase until it hit 99 then go to other while.
    addi, x28, x28, 1 #Keeping increment Z by 1. Basically which it is like this --> z++; 
    j do
   
while: 
	beq x29, x7, exit
	sub x28, x28, x7   #Z--. Decrements by one per each time.
	sub x29, x29, x7
	j while
exit:
	sw x28, 0(x1)
	sw x29, 0(x2)
	

	
	
	
