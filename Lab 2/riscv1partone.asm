#Lab 2 Part 4
#Mahaed Mohamud & Sean Wright
#ECEGR 2220 
#4/

	.data   # Data declaration section

 
 
 z: .word 0
 
	 .text #Readable only section include executable code
 
 main:
 
  li x1, 15 #A x1
  li x2, 10 #B x2
  li x3, 5 #C x3
  li x4, 2 #D x4
  li x5, 18 #E x5 
  li x6, -3 #F x6
  li x7, 0 # Z x7
  
  
  sub s0, x1, x2 # a subtract b in register s0 s0
  
  mul s1, x3 , x4 # c multiply   d in register s1
  
  sub s2, x5, x6 # e subtract f in register s2
  
  div s3, x1, x3 # a is divided by c in  register s3.
  
  add s4, s0, s1 # execute the addition operation of s0 + s1 in register s4 
   
  add s5, s4, s2 # # execute the addition operation of  s4 + s2  in s5  a
   
  sub s6, s5, s3 # execute the subtract operation of  s5- s3 in s6 
  
  sw s6, z, s0 # Store the word in register s6.
