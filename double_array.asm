# int func(int a) { return a + a; }
# data[] の各要素に func を適用して 2 倍にする

        .data
data:   .word 0, 2, 4, 6

        .text
        .globl main

main:
        addi $sp $sp -4         # $ra を退避
        sw $ra 0($sp)

        addi $t0 $zero 4        # num = 4
        la $t1 data             # t1 = data の先頭アドレス
        addi $t2 $zero 0        # i = 0

loop:
        slt $t3 $t2 $t0         # i < num なら $t3 = 1
        beq $t3 $zero end       # i < num でなければ終了

        lw $a0 0($t1)           # 引数 = data[i]
        jal func                # func(data[i])
        sw $v0 0($t1)           # data[i] = 戻り値

        addi $t1 $t1 4          # 次の要素のアドレスへ
        addi $t2 $t2 1          # i++
        j loop

end:
        lw $ra 0($sp)           # $ra を復帰
        addi $sp $sp 4
        jr $ra

func:
        add $v0 $a0 $a0         # return a + a
        jr $ra
