#       Programa em linguagem Assembly que, ao receber um numero N
#       e outro numero x (como entrada pelo usuario), calcula o
#       maior grau a que eh possivel elevar x sem que o resultado
#       ultrapasse o valor de N.
########## EP1
.text
.globl main
main:
        la $a0, $mensagemEntrada
        jal printStr                    #pede para o usuario inserir
        jal readDouble                  #o valor do numero x.
        mov.d $f12,$f0                  #armazena x no registrador f12.
        
        la $a0, $mensagemEntrada2
        jal printStr                    #pede para o usuario inserir
        jal readDouble                  #o valor do numero N.
        mov.d $f14,$f0                  #armazena N no registrador f14.

        l.d $f16, $zeroDouble   #atribui 0 ao registrador f16.
        l.d $f18, $oneDouble    #atribui 1 ao registrador f18.

        c.le.d $f12, $f16       #verifica se x <= 0. caso verdadeiro,
        bc1t printError         #imprime uma mensagem de erro.

        c.le.d $f14, $f16       #verifica se N <= 0. caso verdadeiro,
        bc1t printError         #imprime uma mensagem de erro.

        c.eq.d $f12, $f18       #verifica se x = 1. caso verdadeiro,
        bc1t printError         #imprime uma mensagem de erro.

        jal calculaP            #executa a funcao calculaP.
        
        la $a0, $sucesso        #confirma o sucesso da operacao.
        jal printStr

        la $a0, ($s0)           #imprime o valor de p obtido na operacao.
        jal printInt

        j exit           

calculaP:
        add.d $f20, $f16, $f12  #cria o registrador f20
        c.lt.d $f12, $f14 # if(x < n)
        bc1t calculaPXMenorIgualN
        j calculaPXMaiorN     


calculaPXMenorIgualN:
        c.lt.d $f12, $f18 #if(x < 1)
        bc1t printErroInfinito
        li $s0, 0 # valor inicial de p
        li $s1, 1 # valor de incremento (1 ou -1)
        add.d $f22, $f16, $f12 #cria parâmetro fator a se multiplicar, com valor = x
        j loopXMenorIgualN
        


calculaPXMaiorN:
        li $s0, 1 # valor inicial de p
        c.lt.d $f12, $f18 #if(x < 1)
        bc1t setValoresPPositivo #se x < 1, setValoresPNegativo
        j setValoresPNegativo

setValoresPNegativo: 
        li $s1, -1 # valor de incremento (1 ou -1)
        div.d $f22, $f18, $f12 # valor do fator a se multiplicar, com valor = 1/x
        j loopXMaiorN

setValoresPPositivo:
        li $s1, 1 # valor de incremento (1 ou -1)
        add.d $f22, $f16, $f12 #cria parâmetro fator a se multiplicar, com valor = x
        j loopXMaiorN



loopXMaiorN:
        c.le.d $f20,$f14 #se res <= n, ou seja, se res > n der falso, ele retorna 
        bc1t retorna
        mul.d $f20, $f20, $f22
        add $s0, $s0, $s1
        j loopXMaiorN


loopXMenorIgualN:
        c.lt.d $f14,$f20
        bc1t retorna
        mul.d $f20, $f20, $f22
        add $s0, $s0, $s1
        j loopXMenorIgualN


printInt:
        li $v0,1                       # imprime o resultado
        j syscallAndReturn

printError:
        la $a0, $erro
        jal printStr
	j exit

printStr:
        li $v0,4                        # imprime o resultado
        j syscallAndReturn



readDouble:
        li $v0, 7
        j syscallAndReturn



syscallAndReturn:
        syscall
        j retorna



printErroInfinito:
        la $a0, $erroInfinito
        jal printStr
        j exit

retorna:
       jr $ra   # retorna



exit:
        li $v0,10                        # termina
        syscall

.data
$zeroDouble: .double 0.0
$oneDouble: .double 1.0

$mensagemEntrada:
        .asciiz "\nDigite o valor de x: "

$mensagemEntrada2:
        .asciiz "\nDigite o valor de n: "

$erro:
        .asciiz "\nNão é possível efetuar a operação, já que ou n <= 0, ou x <= 0 ou x = 1"

$erroInfinito:
        .asciiz "\nP é infinito"

$sucesso:
        .asciiz "\nO valor de 'p' obtido foi: "
