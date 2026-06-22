.data
num:    .word 4
data:   .word 0, 2, 4, 6

.text
.globl main

main:
    addi $sp $sp -16
    sw   $ra 0($sp)
    sw   $s0 4($sp)
    sw   $s1 8($sp)
    sw   $s2 12($sp)

    la   $s0 data
    la   $t0 num
    lw   $s1 0($t0)
    add  $s2 $zero $zero

loop:
    slt  $t1 $s2 $s1
    beq  $t1 $zero end
    lw   $a0 0($s0)
    jal  func
    sw   $v0 0($s0)
    addi $s0 $s0 4
    addi $s2 $s2 1
    j    loop

end:
    lw   $ra 0($sp)
    lw   $s0 4($sp)
    lw   $s1 8($sp)
    lw   $s2 12($sp)
    addi $sp $sp 16
    jr   $ra

func:
    add  $v0 $a0 $a0
    jr   $ra
