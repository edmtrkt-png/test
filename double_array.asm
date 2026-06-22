# int func(int a) { return a + a; }
# data[] の各要素に func を適用して 2 倍にする

        .data
data:   .word 0, 2, 4, 6

        .text
        .globl main

main:
        addi $sp $sp -4         # $ra を退避
        sw $ra 0($sp)

        li $t0 4                # num = 4
        la $t1 data             # data の先頭アドレス
        li $t2 0                # i = 0

loop:
        bge $t2 $t0 end         # i >= num なら終了

        sll $t3 $t2 2           # i * 4
        add $t4 $t1 $t3         # &data[i]
        lw $a0 0($t4)           # 引数 = data[i]

        jal func                # func(data[i])

        sw $v0 0($t4)           # data[i] = 戻り値

        addi $t2 $t2 1          # i++
        j loop

end:
        lw $ra 0($sp)           # $ra を復帰
        addi $sp $sp 4
        jr $ra

func:
        add $v0 $a0 $a0         # return a + a
        jr $ra
