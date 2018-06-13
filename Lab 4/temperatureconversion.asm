 #Lab 4 Part 2
#Mahaed Mohamud & Sean Wright
#ECEGR 2220 
#5/ 14/ 2018
#4/

#Main Objective of this part is to create a program that can convert  a value in between Celsius and Kelvin. 
#  Celsius = (Fahrenheit - 32.0 ) * 5.0 / 9.0
#  Kelvin = Celsius + 273.15


	.data # Data declaration section
	
prompt:  .asciz "Enter Temperature in Fahrenheit" 
tempC:   .asciz  "Celsius: "
newLine: .asciz  "\r\n"

tempKelvin:  .asciz "\nKelvin: "

valueFahrenheit:  .float 0 
valueCelsius:     .float 0
valueKelvin:      .float 0
val1: .float  5.0
val2: .float 9.0
val3: .float 32.0
val4: .float 273.15



	.text #Readable only section include executable code
main:

	li a7, 4 #System call for printing a  string 
	la a0, prompt #Print the string of "Enter Temperature in Fahrenheit. 
	ecall          #Execute it. 
	
	li a7, 6 #System call for reading a float number from input console. 
	ecall          #Execute it.
	 
	fmv.s ft1, fa0   #Save the result from the user via the console . 
	
	fsw f10, valueFahrenheit , t0  #Save the value of ValueFahrenheit to f10. 
	
	jal tempConversionFormula
	
	li a7, 4
	la a0, newLine  #Print the next line. 
	ecall
	
	li a7, 4
	la a0, tempC #Print the string of Temperature in Celsius. 
	ecall
	
	flw fa0, valueCelsius, t0  #Load value in Celsius and print it. 
	li a7, 2
	ecall 
	
	li a7, 4
	la a0, newLine  #Print the next line in order to initate the conversion operation and print the next two values. 
	ecall
	
	flw fa0, valueKelvin, t0 #Load value in Kelvin and print it.
	li a7, 2
	ecall

	
	li a7, 10 #System call for exit. 
	ecall	

tempConversionFormula: 
	#Use f1, f2, f3, f4 for arithmetic operation.
	
	
	flw  f0, valueFahrenheit, t0 #Load the value of temperature in Fahrenheit that was entered onto the input console. 
	flw  f1, val1, t0 #Load val1 into f5. Value of 5.0.
	flw  f2, val2, t0 #Load val2 into f6. Value of 9.0.
	flw  f3, val3, t0 #Load val3 into f7. Value of 32.0. 
	flw  f4, val4, t0 #Load val4 into f8. Value of 273.15.  
	
	fsub.s f0, f0, f3  #Fahrenheit - 32.0. First Operation 
	
	fmul.s f0, f0, f1   # (Fahrenheit - 32.0 ) * 5. Second Operation.
	fdiv.s f0, f0, f2   #  # (Fahrenheit - 32.0 ) * 5 / 9. Third Operation. 
	
	fsw f0, valueFahrenheit, t0  #Store the result after completing the conversion operation.
	
	fadd.s f0, f0, f4 #Add 273.15 to properly convert it between Celsius to Kelvin. 
	fsw f0, valueFahrenheit, t0  #Store the another result after completing the second conversion operation again.
	
	ret 
	

	
	
	


