#Lab 4 Part 3
#Mahaed Mohamud & Sean Wright
#ECEGR 2220 
#4/
#The Main Objective of this part is to generate a program that incorporate all of those RISC-V instructions that the ALU firmly supports.




		.text #Readable only section include executable code
main:	


	#Profusely test the regular add(add) Operation.
	li t0 0x00000001
	li t1 0x01234567

	add s0 t0 t1
	
	#Profusely test the regular subtract (sub) Operation.
	li t0, 0x00000002
	li t1, 0x00000001
	sub s1, t0, t1

	#Profusely test the regular add Immediate(Addi) Operation. 
	li t0, 0x00000001
	addi s2, t0, 0x00000001
	
	#Profusely test the regular and  (and)  Operation.
	li t0, 0x11111111
	li t1, 0x00000000
	and s3, t0, t1
	
	#Profusely test the and Immediate (andi)  Operation.
	li t0, 0x00100000
	andi s4, t0, 0x00001 
	
	#Profusely test the regular OR (or)  Operation.
	li t0, 0x10101010
	li t1, 0x01010101
	or s5, t0, t1

	#Profusely test the Or Immediate(ori) Operation.
	li t0,0x00000001
	ori s6, t0, 0x00000001

	#Profusely test the Shift Left(sll) Operation.
	li t0, 0x11111110
	li t1, 0x00000001
	sll s7, t0, t1

	#Profusely test the Shift Right(srl) Operation.
	srl s8, t0, t1

	
	li a7, 10  #Instantly Exit the program once  it is completed.

	ecall      #System call for exiting. 