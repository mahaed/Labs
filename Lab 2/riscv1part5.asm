#Lab 2 Part 5
#Mahaed Mohamud & Sean Wright
#ECEGR 2220 
#4/



	.data # Data declaration section
	
a: .word 0
 
b: .word 0

c: .word 0 
	
	.text #Readable only section include executable code
	
main:
	addi t0, x0, 5  #set i to 5.
	addi t1, x0, 10 #set j to 10.
	
	addi sp, sp, -8 #Adjust the stack pointer for i and j in order to create a stack to store these two values. 
	sw   t0, 0(sp)  #Store the value of 5 in the stack firstly.
	sw   t1, 4(sp)  #Store the value of 10 in the stack secondly.
	
	jal  AddItUp    #Go to AddItUp function. 
	
	sw   a0, a, t6 #Store AddItUp(i) into a. 
	lw   s2, a    #Load a into register s2 to save A. 
	
	lw   t0, 0(sp)  #restore the value of 5 back into register t0.
	lw   t1, 4(sp)  #restore the value of 10 back into register t1. 
	addi sp, sp, 8  #Shrink the stack up by 8 bytes.
	
	
	addi sp, sp, -8 #Re-adjust the stack pointer for i and j in order to create a stack to store these two values. 
	sw   t1, 0(sp) #Store the value of 10 in the stack firstly instead.
	sw   t0, 4(sp) #Store the value of 5 in the stack secondly instead. 
	
	
	jal  AddItUp    #Go to AddItUp function again.
	
	sw   a0, b, t6 #Store AddItUp(j) into b.
	lw   s3, b     #Load b into register s3 to save b.
	
	add t5, s2, s3 # add a and b together. 
	sw  t5,  c, t6 #Store the result of adding a and b together into c.
	lw  s4,  c 
	 
	j exit         #Go directly to Exit to end this program. 
	
	

AddItUp:
	lw   a2, 0(sp) #Load the value of n into this register a1 to be used as function arguments to be passed down in forloop. 
	addi t0, x0, 0 #Set x = 0
	addi t1, x0, 0 #Set i = 0 before going to the for loop to run. 
	j    forTheloop    #Go to the for loop to execute.
	
forTheloop:
	add  t0, t0, t1 #Firstly, add x + i. 
	addi t0, t0, 1 # Then add to it by 1. Therefore, it will be X = X + i + 1. 
	addi t1, t1, 1 #Increment I by 1 after the end of each loop until it fails the condition for the for loop. 
	blt  t1, a2, forTheloop  #Check if i < n when n is 5 for a and n is 10 for b. 
	add  a0, x0, t0 #Store the final value of x. 
	ret            #Return the value of x. 
	
exit:
	li a7, 10 #Exit the program 
 	ecall



