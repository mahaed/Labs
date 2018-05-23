 #Lab 2 Part 4
#Mahaed Mohamud & Sean Wright
#ECEGR 2220 
#4/

	.data # Data declaration section
arrayA:	.space  20
arrayB:	.word   1, 2, 4 , 8, 16

	.text #Readable only section include executable code
main:

 # Read variables from memory to registers
 	li t1, 0 #Load initial value of i to start increment in the for loop.
 	la s1, arrayA #Load Array A reference into register s1.
 	la s0, arrayB #Load Array B into register s0
	
 #####################
 #Now, go to run the for loop.
 
 loop:
 	slti t0, t1, 5 #If value of i is less than 5, then t0 = 1 (True). Else, its false and t0 = 0 then go to endFor
 	beq t0, x0, EndForloop 
 	slli t2, t1, 2  #Shifting the value of i by 2^2 which is 4 bytes so it traverse across each element index for B.
 	add t3, t2, s0 #Pointer to the address of arrayB then  add the shifted value of i to the ArrayB
 	lw t4, 0(t3)  #Load the B[i] in the register t4(reading data from memory to regsister). Which is t4 = b[i]. 
 	addi t4, t4, -1 #Subtract 1 from value of B[i]. Basically, its B[i] - 1. 
 	slli t5, t1, 2 #Shifting the value of i by 2^2 left which is 4 bytes so it traverse across each element index for A.
 	add t6, t5, s1 #Pointer to the address of arrayA then  add the shifted value of i to the ArrayA
 	sw t4, 0(t6) #Store the value of B[i] -1 into the memory of A[i]. Basically, A[i] = B[i] - 1. 
 	addi t1, t1, 1 #Increment the value of i by one per each time it execute the loop. 
 	j loop  #Repeat the loop until it fails the loop condition. 
 	
 	

 EndForloop:
 	addi t1, t1, -1 #i--. Decrements the value of i by one per each time.
 	
 	addi a0, x0, -1 #load another register with a -1. 
 	
	li s2, 2 #Load another register with a 2.
 while:
 	slt t0, a0, t1 #If value of i is greater than  0, then t0 = 1(True). Else, its false when its less than 0  and keep going until its less than 0 then exit.
 	beq t0, x0, endWhile #When value of i less than 0 then it go to endwhile to exit out the while loop and exit this program. 
 	slli t2, t1, 2  #Shifting the value of i by 2^2 left which is 4 bytes so it traverse across each element index for B.
 	add  t2, t2, s1 #Pointer to the address of arrayA then  add the shifted value of i to the ArrayA
 	lw  t3, 0(t2)  #Load the A[i] in the register t4(reading data from memory to regsister). Which is t4 = A[i]. 
 	
 	
 	slli t4, t1, 2  #Shifting the value of i by 2^2 left which is 4 bytes so it traverse across each element index for B.
 	
 	add t4, t4, s0  #Pointer to the address of arrayB then  add the shifted value of i to the ArrayB.
 	lw  t5, 0(t4)   #Load the B[i] in the register t5(reading data from memory to regsister). Which is t5 = B[i]. 
 	add t5, t5, t3  #Add A[i] + B[i] together.
 	mul t5, t5, s2  #Multiply (A[i]+ B[i]) by 2. 
 	sw  t5, 0(t2)   #Store the (A[i]+ B[i]) * 2 to A[1] in the register t4.
 	addi t1, t1, -1 #Decrement the value of i by one.
 	j while
 	
endWhile:
 	li a7, 10 #Exit the program 
 	ecall
 
 
 
 
 
 	 
