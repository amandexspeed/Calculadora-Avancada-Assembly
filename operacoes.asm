.data
	INSSBase: .float 105.90
	INSS1:	.float 1412.00
	INSS2:	.float 2666.68
	INSS3:	.float 4000.03
	INSS4:	.float 7786.02
	
	constINSS4: .float 908.86
	constINSS3: .float 272.92
	constINSS2: .float 112.92
	
	coefINSS3: .float 0.14
	coefINSS2: .float 0.12
	coefINSS1: .float 0.09
	
	IRPFBase: .float 12
	IRPF1:	.float 25344.00
	IRPF2:	.float 38532.00
	IRPF3:	.float 50568.00
	IRPF4:	.float 63816.00
	
	constIRPF4: .float 5775.30
	constIRPF3: .float 2794.50
	constIRPF2: .float 989.10
	
	coefIRPF4: .float 0.275
	coefIRPF3: .float 0.225
	coefIRPF2: .float 0.15
	coefIRPF1: .float 0.075
	 
	constIRPJ: .float 20000
	
	coefIRPJ2: .float 0.1
	coefIRPJ1: .float 0.15
	
	coe100: .float 100
	
	buffer: .space 32
	bufferSaida: .space 32 
	
.text

.globl soma
.globl multiplicacao
.globl subtracao
.globl divisao
.globl potencia

.globl INSS
.globl IRPF
.globl IRPJ
.globl IPVA
.globl IPTU

#.globl decBin
#.globl hexBin
#.globl octBin

#.globl hexDec
#.globl binDec
#.globl octDec

.globl toBin
.globl toDec
.globl toHex
.globl toOctal

#.globl binHex
#.globl octHex
#.globl decHex

soma:

    add $v0, $a1, $a2  # Soma $t0 e $t1, resultado em $v0
    jr $ra
    
subtracao:
   sub $v0, $a1, $a2
   jr $ra
   
multiplicacao:
   mul $v0, $a1, $a2
   jr $ra
   
divisao:
   li $v0,0
   beqz $a2,fimDivisao
   div $v0, $a1, $a2
   fimDivisao:
   	jr $ra
   	
potencia:
    li $v0, 1               # Inicializa o resultado como 1
    move $t9,$a2
power_loop:
    beq $t9, 0, end_power   # Se o expoente for 0, retorna $v0(inicializado como 1)
    mul $v0, $v0, $a1      # Multiplica o resultado pela base
    subi $t9, $t9, 1        # Decrementa o expoente
    j power_loop            # Continua o loop

end_power:
    jr $ra                  # Retorna para a função principal
   
INSS:
  #$f0 -> valor do salário -> atributo
  #$f1 -> Faixa salarial
  #$f2 -> Resultado
  #$f3 -> restante para cálculo
  #$f4 -> registrador intermediário para valores

  lwc1 $f2 INSSBase
  
  lwc1 $f1 INSS4 # testa se é maior que 7786.02
  c.lt.s $f0,$f1 
  bc1f quartaFaixaINSS
  
  lwc1 $f1 INSS3 # testa se é maior que 4000.03
  c.lt.s $f0,$f1
  bc1f terceiraFaixaINSS
  
  lwc1 $f1 INSS2 # testa se é maior que 2666.68
  c.lt.s $f0,$f1
  bc1f segundaFaixaINSS
  
  lwc1 $f1 INSS1 # testa se é maior que 1412.00
  c.lt.s $f0,$f1
  bc1f primeiraFaixaINSS
  
  lwc1 $f1 INSS1 # testa se é menor que 1412.00
  c.lt.s $f0,$f1
  bc1t abaixoSalMin
  
  #bgt $a1,7786.02,quartaFaixa
  #bgt $a1,4000.03,terceiraFaixa
  #bgt $a1,2666.68,segundaFaixa
  #bgt $a1,1412.00,primeiraFaixa
  #blt $a1,1412.00,abaixoSalMin
  
  jr $ra
  
  quartaFaixaINSS:
  
  	lwc1 $f0,constINSS4
  	jr $ra 
  	
  
  terceiraFaixaINSS:
  
  	lwc1 $f4,constINSS3
  	add.s $f2,$f2,$f4
  	sub.s $f3,$f0,$f1
  	lwc1 $f4,coefINSS3
  	mul.s $f4, $f3, $f4
  	add.s $f2,$f2,$f4
  	jr $ra 
  	
  
  segundaFaixaINSS:
  
 	lwc1 $f4,constINSS2
  	add.s $f2,$f2,$f4
  	sub.s $f3,$f0,$f1
  	lwc1 $f4,coefINSS2
  	mul.s $f4, $f3, $f4
  	add.s $f2,$f2,$f4
  	jr $ra 
  
  primeiraFaixaINSS:
  
  	sub.s $f3,$f0,$f1
  	lwc1 $f4,coefINSS1
  	mul.s $f4, $f3, $f4
  	add.s $f2,$f2,$f4
  	jr $ra 
  
  abaixoSalMin:
 	mtc1 $zero, $f0
  	jr $ra
  
IRPF:
#$f0 -> salário -> atributo
#$f1 -> deduções a reduzir -> atributo
#$f2 -> resultado
#$f3 -> rendimentos anuais
#$f4 -> base de cálculo
#$f5 -> intermediário
  
  lwc1 $f5 IRPFBase
  mul.s $f3, $f0, $f5
  sub.s $f4, $f3, $f1
  
  lwc1 $f5 IRPF4 # testa se é maior que 63816.00
  c.lt.s $f0,$f5 
  bc1f quartaFaixaIRPF
  
  lwc1 $f1 IRPF3 # testa se é maior que 50568.00
  c.lt.s $f0,$f5
  bc1f terceiraFaixaIRPF
  
  
  lwc1 $f1 IRPF2 # testa se é maior que 38532.00
  c.lt.s $f0,$f5
  bc1f segundaFaixaIRPF
  
  lwc1 $f1 IRPF1 # testa se é maior que 25344.00
  c.lt.s $f0,$f5
  bc1f primeiraFaixaIRPF
  
  mtc1 $zero, $f2
  jr $ra	#isento
  
  quartaFaixaIRPF:
  
  	lwc1 $f5,constIRPF4
  	sub.s $f2,$f4,$f5
  	lwc1 $f5,coefIRPF4
  	mul.s $f2, $f2,$f5
  	jr $ra 
  
  terceiraFaixaIRPF:
  
  	lwc1 $f5,constIRPF3
  	sub.s $f2,$f4,$f5
  	lwc1 $f5,coefIRPF3
  	mul.s $f2, $f2,$f5
  	jr $ra 
  	
  
  segundaFaixaIRPF:
  
 	lwc1 $f5,constIRPF2
  	sub.s $f2,$f4,$f5
  	lwc1 $f5,coefIRPF2
  	mul.s $f2, $f2,$f5
  	jr $ra 
  
  primeiraFaixaIRPF:
  	
  	mtc1 $zero, $f5
  	sub.s $f2,$f4,$f5
  	lwc1 $f5,coefIRPF1
  	mul.s $f2, $f2,$f5 
  	jr $ra 
  
  

IRPJ:
#$f0 -> Lucro mensal -> atributo
#f2 -> Resultado
#f1 e $f3 -> intermediários


	lwc1 $f1,constIRPJ
	
	c.lt.s $f0,$f1
	bc1t calcBasico
	
	sub.s $f3,$f0,$f1
	lwc1 $f1,coefIRPJ2
	mul.s $f2,$f3,$f1
	
	calcBasico:
	lwc1 $f1,coefIRPJ1
	mul.s $f3,$f0,$f1
	add.s $f2,$f2,$f3
	jr $ra

IPVA:
#$f0 -> valor do carro
#$f1 -> aliquota
#$f2 -> resultado
	lwc1 $f3,coe100
	div.s $f3,$f1,$f3
	mul.s $f2,$f0,$f3
	jr $ra

IPTU:
#$f0 -> valor do imóvel
#$f1 -> aliquota
#$f2 -> resultado

	lwc1 $f3,coe100
	div.s $f3,$f1,$f3
	mul.s $f2,$f0,$f3
	jr $ra

#Para calculadora de TI:
#$a0 - valor
#$a1 - Base
#$v0 - Registrador para salvar os bits
#$t3 - deslocamento
#$t4 - contador 32 bits
#$t5 - resultado MOD



#decBin:
#hexBin:
#octBin:

toBin:

    li $t3, 0       # Inicializa o registrador para armazenar o bit
    li $t4, 32      # Conta de 32 bits
    
    conversionBin:
    	beq $t4, 0, done
    	rem $t5, $a0, 2  # Resto da divisão por 2 (próximo bit)
    	div $t1, $a0, 2  # Divide o número por 2
    	add $v0, $v0, $t5 # Concatena o bit ao resultado
    	sllv $v0, $v0, $t3    # Desloca o resultado para a esquerda
    	subi $t4, $t4, 1
    	j conversionBin
    
    done: 
	srlv $v0, $v0, $t3
	jr $ra

#hexDec:
#binDec:
#octDec:

toDec:
 
    li $a2, 0 # Inicializa o contador de caracteres 
    li $v0, 0
    
    move $t6, $ra
       	
       	jal reverterString
       	
    move $ra, $t6
    
    li $t0, 0 # Inicializa o acumulador para o resultado decimal
    
    next_char: 
    	lb $t2, 0($a0) # Carrega o próximo caractere da string 
    	beq $t2, 10 , end_conversion # Termina se o caractere for NULL 
    	# Converter caractere para valor numérico 
    	li $t3, 45
    	sub $t2, $t2, $t3
    	beqz $t2, negativo # Termina se o caractere for '-'
    	
    	bltz $t2, end_conversion # termina se for outra coisa aleatória
    	
    	subi $t2, $t2, 3 #ajusta valor para os números
    	
    	# Converte o caractere '0'-'9' para 0-9 
    	blt $t2, 10, update_result 
    	
    	# Converte caractere 'A'-'F' para 10-15 (hexadecimal) 
    	li $t3, 7 
    	#sub $t3, $t3, '0'
    	sub $t2, $t2, $t3 
    	#addi $t2, $t2, 10 # Adiciona 10 para caracteres A-F 
    update_result: 
  
       	move $t6, $ra
       	
       	jal potencia
       	
       	move $ra, $t6
       	
       	mul $t4, $t2, $v0 # Multiplica o resultado atual pelo resultado da potência
       	
       	add $t0, $t0, $t4 # Adiciona o valor numérico ao resultado 
       	addi $a0, $a0, 1 # Incrementa o ponteiro da string 
       	addi $a2, $a2, 1
       	
        j next_char 
        
    end_conversion: 
    	move $v0, $t0 # Retorna o resultado em $v0 
    	jr $ra # Retorna para a função principal
    	
    negativo:
    	mul $v0,$t0,-1
    	jr $ra


#binHex:
#octHex:
#decHex:

toHex:

    #jal toDec    # Converter a string para decimal

    # Conversão de decimal para hexadecimal
    move $t0, $v0            # Resultado decimal em $t0
    la $a0, buffer           # Ponto para salvar a string hexadecimal
    li $t1, 0x10             # Base hexadecimal
    li $t2, '0'              # Caractere '0'

    decimal_to_hexadecimal:
       divu $t3, $t0, $t1       # Divide $t0 por 16
       mfhi $t4                 # Pega o resto da divisão
       blt $t4, 10, convert_digit
       #addi $t4, $t4, ('A' - '0' - 10)
       addi $t4, $t4,7
    convert_digit:
       add $t4, $t4, $t2        # Converte o dígito para caractere
       sb $t4, 0($a0)           # Salva o caractere no buffer
       addi $a0, $a0, 1         # Incrementa o ponteiro do buffer
       move $t0, $t3            # Atualiza $t0 com o quociente
       bne $t0, 10, decimal_to_hexadecimal

       li $t9,10
       sb $t9,0($a0)        # Adiciona NULL ao fim da string
       # $a0 contém a string hexadecimal
       la $v0,buffer
       jr $ra


toOctal:

    #jal toDec    # Converter a string para decimal

    # Conversão de decimal para octal
    move $t0, $v0            # Resultado decimal em $t0
    la $a0, buffer          # Ponto para salvar a string octal
    li $t1, 8                # Base octal
    li $t2, '0'              # Caractere '0'
calculo:
    divu $t3, $t0, $t1       # Divide $t0 por 8
    mfhi $t4                 # Pega o resto da divisão
    add $t4, $t4, $t2        # Converte o dígito para caractere
    sb $t4, 0($a0)           # Salva o caractere no buffer
    addi $a0, $a0, 1         # Incrementa o ponteiro do buffer
    move $t0, $t3            # Atualiza $t0 com o quociente
    bnez $t0, calculo

    sb $zero, 0($a0)         # Adiciona NULL ao fim da string
    
    # A string octal está agora em buffer (reversa, precisará inverter)
    
reverterString:
    # Primeiro, precisamos calcular o comprimento da string
    li $t5, 10
    move $t0, $a0           # Salva o ponteiro original da string em $t0
    li $t1, 0               # Inicializa o comprimento da string
    la $t3, bufferSaida

calculate_length:
    lb $t2, 0($t0)          # Carrega o próximo caractere da string
    #beqz $t2,start_reverse
    beq $t2, $t5, start_reverse # Se o caractere for NULL, termina a contagem
    addi $t0, $t0, 1        # Incrementa o ponteiro da string
    addi $t1, $t1, 1        # Incrementa o comprimento da string
    j calculate_length

start_reverse:
    #move $t3, $a0
    #subi $t1,$t1,1
    
reverse_loop:
    
    bltz $t1, add_null # Se o comprimento for negativo, adiciona NULL e termina 
    lb $t4, 0($t0) # Carrega o caractere do final da string original 
    sb $t4, 0($t3) # Salva o caractere no buffer de saída 
    add $t3, $t3, 1 # incrementa o ponteiro do buffer de saída 
    subi $t0, $t0, 1 # Decrementa o ponteiro da string original 
    subi $t1, $t1, 1 # Decrementa o comprimento da string 
    j reverse_loop

add_null:
    #sb $t5,0($t3)       # Adiciona o caractere NULL ao final da string invertida
    la $a0,bufferSaida
    add $a0, $a0,1
    jr $ra                  # Retorna para a função principal


    
   
