 #Lab 2 Part 2
#Mahaed Mohamud & Sean Wright
#ECEGR 2220 
#4/

	.data	# Data declaration section
	
A:	.word 10
B:	.word 15
C:	.word 15
Z:	.word 0
	

	.text #Readable only section include executable code
main:
	la x11, A
	li x1, 10  #A
	
	la x12,B
	li x2, 15  #B
	
	la x13, C
	li x3, 6   #C
	
	
	la x31,Z
	li x4, 0   #z
	
	addi x5, x3, 1 #add c + 1 for the second conditional statement in the second  else if statement
	addi x6, x0, 7 #assigning  7 to x6 register in order to be incorporated in the second conditional statement in else if statement
	addi x7, x0, 5 #assigning 5 to x7 register in order to be incorporated in the first conditional statement in the if statement.
	li   x8,  1
	
	
	slt x14, x1, x2 #The opposite of A < B which is B < A . Check if B not greater than A then its false to move on to else if statement.
	beq x14, x0 Elseif #check if z = 0 then set it equal to 1. 
	slt x14, x7, x3 #the opposite of C > 5 in the first conditional statement in the if statement and move on to else if statement.
	beq x14, x0 Elseif #check if z = 0 then set it equal to 1. 
	
	j switchcase1
	
	Elseif: 

	slt x15, x2, x1  #the opposite of  A > B which is  A < B.
	beq x15, x8 switchcase2 #go to switch case 2 if B >A
	beq x6, x3, switchcase2 #go to switch  case 2 if 7 == C +1
	j Else
	
	Else:
	j switchcase3
	
	
switchcase1:
	addi x4, x0, -1 #z = -1
	j Exit 
	
	
switchcase2:
	addi x4, x0, -2 #z = - 2
	
	 j Exit
	 
switchcase3:
	addi x4, x0, -3 #z = -3
	
	
	Exit:
	li 	x4, 0
	sw x1,0(x11)
	sw x2,0(x12)
	sw x3,0(x13)
	sw x4,0(x31)
	

