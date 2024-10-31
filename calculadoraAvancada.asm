.data
menu: .asciiz "\nMenu:\n1 - Calculadora simples\n2 - Calculadora de impostos\n3 - Calculadora para TI\nEscolha uma opcao: "

menuCalcSimples: .asciiz "\nOpções:\n1 - Soma\n2 - Subtração\n3 - Multiplicação\n4 - Divisão\n5 - Potência\nEscolha uma opcao: "
menuCalcImpostos: .asciiz "\nOpções:\n1 - INSS\n2 - Imposto de Renda - Pessoa física\n3 - Imposto de Renda - Pessoa jurídica\n4 - IPVA\n5 - IPTU\nEscolha uma opcao: "
menuCalcTI: .asciiz  "Para qual base você deseja converter?\n2 - Binário\n16 - Hexadecimal\n"
#menuCalcTI2: .asciiz "Qual é a base do número original?\n2 - Binário\n8 - Octal\n10 - Decimal\n16 - Hexadecimal\n"

strCalcTI: .asciiz "\nDigite o número desejado para conversão: "
strLaco: .asciiz "\nDeseja fazer mais alguma operação? Digite 1 para sim e qualquer outro número para não: "
strResultado: .asciiz "\nO resultado foi:"
strCalculoInvalido: .asciiz "\nNão é possível realizar essa operação"
strCalcSimplesOp1: .asciiz "\nDigite o primeiro termo: "
strCalcSimplesOp2: .asciiz "\nDigite o segundo termo: "
strImpostoRendaPF1: .asciiz "\nDigite o salário: "
strImpostoRendaPF2: .asciiz "\nDigite o valor a descontar: "
strImpostoRendaPJ: .asciiz "\nDigite o lucro: "
strInss: .asciiz "\nDigite o salário: "
strIptu1: .asciiz "\nDigite o valor do imóvel: "
strIptu2: .asciiz "\nDigite a aliquota(em percentual): "
strIpva1: .asciiz "\nDigite o valor do automóvel: "
strIpva2: .asciiz "\nDigite a aliquota(em percentual): "
strIsento: .asciiz "\nVocê é isento de imposto de renda!"
opInv: .asciiz "\nOpção inválida! Digite outra opção: "

opcao: .word 0
opcaoMenuSec: .word 0

resultado: .word 0
operando1: .word 0
operando2: .word 0

resultadoString: .asciiz ""

resultadoFloat: .float 0
operando1Float: .float 0
operando2Float: .float 0

buffer: .space 32 

.text
.globl main


#Registradores para não sobreescrever e seus significados:
# $s0 -> 1º escolha(modulo usado)
# $s1 -> 2º escolha(opção escolhida do módulo) 
# $s2 -> Resultado
# $a1 -> 1º operando
# $a2 -> 2° operando
# $f2 -> Resultado(Impostos)
# $f0 -> 1º operando(Impostos)
# $f1 -> 2° operando(Impostos)



main:
    # Exibe o menu
    li $v0, 4          # syscall para imprimir string
    la $a0, menu       # carrega o endereço da string do menu
    syscall

    # Captura a resposta do usuário
    li $v0, 5          # syscall para ler inteiro
    syscall
    sw $v0, opcao      # armazena a resposta na variável opcao

    # Carrega a resposta do usuário
    lw $s0, opcao

    # Verifica a opção escolhida
    li $t0, 1
    beq $s0, $t0, opcao1
    li $t0, 2
    beq $s0, $t0, opcao2
    li $t0, 3
    beq $s0, $t0, opcao3

    # Se a opção não for válida, avisa ao usuário
    j opcaoInvalida

opcao1:
    # Exibe o menu da calculadora simples
    li $v0, 4
    la $a0, menuCalcSimples
    syscall
    
    # Captura a resposta do usuário
    li $v0, 5
    syscall
    sw $v0, opcaoMenuSec
    
    # Carrega a resposta do usuário
    lw $s1, opcaoMenuSec
    
    # Verifica se a opção escolhida é válida
    
    blez $s1,opcaoInvalida  #menor ou igual a zero
    bgt $s1,5,opcaoInvalida
    
    # Exibe mensagem pra o primeiro operando caso a opção seja válida
    li $v0, 4          # syscall para imprimir string
    la $a0, strCalcSimplesOp1       # carrega o endereço da string
    syscall

    # Captura a resposta do usuário
    li $v0, 5          # syscall para ler inteiro
    syscall
    sw $v0, operando1      # armazena a resposta na variável 
   	 
    # Exibe mensagem pra o segundo operando 
    li $v0, 4          # syscall para imprimir string
    la $a0, strCalcSimplesOp2       # carrega o endereço da string
    syscall

   # Captura a resposta do usuário
   li $v0, 5          # syscall para ler inteiro
   syscall
   sw $v0, operando2      # armazena a resposta na variável 
   
   #Passa a resposta pra registrador
   lw $a1, operando1
   lw $a2, operando2
   
   
   #divide os caminhos de processamento
   
   beq $s1,1,chamaSoma
   beq $s1,2,chamaSubtracao
   beq $s1,3,chamaMultiplicacao
   beq $s1,4,chamaDivisao
   beq $s1,5,chamaPotencia
   
    	
   chamaSoma:
     jal soma
     j imprimeResultado
     
   chamaSubtracao:
     jal subtracao
     j imprimeResultado
   
   chamaMultiplicacao:
     jal multiplicacao
     j imprimeResultado	
   
   chamaDivisao:
     jal divisao
     bgtz $v0,imprimeResultado
     beqz $a2,calculoInvalido
     #Essas verificações são para detectar divisões por 0, já que se o 2° parâmetro for 0 a função retorna 0
     
   chamaPotencia:
     jal potencia
     j imprimeResultado	
     
opcao2:
    # Código para a Calculadora de impostos
    # Exibe o menu da calculadora de impostos
    li $v0, 4
    la $a0, menuCalcImpostos
    syscall
    
    # Captura a resposta do usuário
    li $v0, 5
    syscall
    sw $v0, opcaoMenuSec
    
    # Carrega a resposta do usuário
    lw $s1, opcaoMenuSec
    
    # Verifica se a opção escolhida é válida
    
    blez $s1,opcaoInvalida  #menor ou igual a zero
    bgt $s1,5,opcaoInvalida
    separaProc:
    
    	beq $s1,1,chamaINSS
    	beq $s1,2,chamaIRPF
   	beq $s1,3,chamaIRPJ
    	beq $s1,4,chamaIPVA
    	beq $s1,5,chamaIPTU
    	
   	chamaINSS:
   	  li $v0, 4
  	  la $a0, strInss
    	  syscall
    
    	  li $v0, 6          # syscall para ler float(Salário)
    	  syscall
    	  swc1 $f0, operando1Float 
    	  
    	  jal INSS
    	  mtc1 $zero, $f3
     	  c.eq.s $f2,$f3
     	  bc1t calculoInvalido
     	  j imprimeResultadoFloat
     
  	chamaIRPF:
  	  
  	  li $v0, 4
    	  la $a0, strImpostoRendaPF1
    	  syscall
    
    	  li $v0, 6          # syscall para ler float(Salário)
    	  syscall
    	  swc1 $f0, operando1Float 
    
      	  li $v0, 4
    	  la $a0, strImpostoRendaPF2
    	  syscall
    
    	  li $v0, 6          # syscall para ler float(Descontos)
    	  syscall
   	  swc1 $f0, operando2Float 
    
    	  # Carrega a resposta do usuário
    	  lwc1 $f0, operando1Float 
    	  lwc1 $f1, operando2Float 
  	
     	  jal IRPF
     	  mtc1 $zero, $f3
     	  c.eq.s $f2,$f3
     	  bc1f imprimeResultadoFloat
     	  li $v0, 4          # syscall para imprimir string
    	  la $a0, strIsento       # carrega o endereço da string
   	  syscall
   	  j laco
     	  
   
   	chamaIRPJ:
   	
   	  li $v0, 4
  	  la $a0, strImpostoRendaPJ
    	  syscall
    
    	  li $v0, 6          # syscall para ler float(Lucros)
    	  syscall
    	  swc1 $f0, operando1Float
   	
     	  jal IRPJ
     	  j imprimeResultadoFloat
     	  
     	  	
   
   	chamaIPVA:
   	
   	  li $v0, 4
    	  la $a0, strIpva1
    	  syscall
    
    	  li $v0, 6          # syscall para ler float(Valor venal)
    	  syscall
    	  swc1 $f0, operando1Float 
    
    	  li $v0, 4
    	  la $a0, strIpva2
    	  syscall
    
    	  li $v0, 6          # syscall para ler float(Alíquota)
    	  syscall
   	  swc1 $f0, operando2Float 
    
   	  # Carrega a resposta do usuário
    	  lwc1 $f0, operando1Float 
   	  lwc1 $f1, operando2Float 
   	
     	  jal IPVA
     	  
     	  j imprimeResultadoFloat
     	  
     	chamaIPTU:
     	
     	  li $v0, 4
    	  la $a0, strIptu1
    	  syscall
    
    	  li $v0, 6          # syscall para ler float(Valor venal)
    	  syscall
    	  swc1 $f0, operando1Float 
    
    	  li $v0, 4
    	  la $a0, strIptu2
    	  syscall
    
    	  li $v0, 6          # syscall para ler float(Alíquota)
    	  syscall
   	  swc1 $f0, operando2Float 
    
   	  # Carrega a resposta do usuário
    	  lwc1 $f0, operando1Float 
   	  lwc1 $f1, operando2Float 
     	
      	  jal IPTU
     	  j imprimeResultadoFloat
   
   

opcao3:
    # Código para a Calculadora para TI
 
    li $v0, 4          # syscall para imprimir string
    la $a0, menuCalcTI       # carrega o endereço da string do menu
    syscall

    # Captura a resposta do usuário
    li $v0, 5          # syscall para ler inteiro
    syscall
    sw $v0, opcao      # armazena a resposta na variável opcao

    # Carrega a resposta do usuário
    lw $s0, opcao
    
    beq $s0,2,casoStr
    beq $s0,16,casoStr
    j calculoInvalido
    casoStr:
    	# Exibe mensagem pra o número caso a opção seja válida
    	li $v0, 4          # syscall para imprimir string
    	la $a0, strCalcTI   # carrega o endereço da string
    	syscall
    	
    	li $v0, 8               # syscall para ler uma string
   	la $a0, buffer          # endereço do buffer
   	li $a1, 32             # tamanho máximo da string
    	syscall                 # chama o syscall
    
	la $a0, buffer
	move $a1,$s0
    	jal toDec
    	move $a0,$v0
    	
    	j imprimeResultado
    
    j laco

imprimeResultado:
     sw $v0,resultado
     lw $s2,resultado
     
     li $v0, 4          # syscall para imprimir string
     la $a0, strResultado       # carrega o endereço da string
     syscall
     
     move $a0,$s2
     li $v0,1
     syscall
     j laco
     

     
imprimeResultadoFloat:
     swc1 $f2,resultadoFloat
     lwc1 $f12,resultado
     
     li $v0, 4          # syscall para imprimir string
     la $a0, strResultado       # carrega o endereço da string
     syscall
     
     li $v0,2
     syscall
     j laco

calculoInvalido:
    #Caso a operação que o usuário pedir for inválida
    li $v0, 4          # syscall para imprimir string
    la $a0, strCalculoInvalido       # carrega o endereço da string do mensagem de opção inválida
    syscall
    j laco

opcaoInvalida:
    #Caso o usuário digitar uma opção inválida
    li $v0, 4          # syscall para imprimir string
    la $a0, opInv       # carrega o endereço da string do mensagem de opção inválida
    syscall
    
laco:
    li $v0,4
    la $a0, strLaco
    syscall
    
    li $v0, 5          # syscall para ler inteiro
    syscall
    sw $v0, opcao      # armazena a resposta na variável opcao
    lw $t0, opcao      # Carrega a resposta do usuário

    # Verifica a opção escolhida
    li $t1, 1
    beq $t0, $t1, main
     
    
fim:
    li $v0, 10         # syscall para terminar o programa
    syscall
