#==============================================================
# double_array.asm
#
# 以下の C 言語プログラムと同じ動作をする MIPS アセンブリ
#
#   int func(int a) {
#       return a + a;
#   }
#   int main() {
#       int num = 4;
#       int data[] = {0, 2, 4, 6};
#       for (int i = 0; i < num; i++) {
#           data[i] = func(data[i]);
#       }
#       return 0;
#   }
#
# 実行結果: data[] の各要素が 2 倍になる
#           {0, 2, 4, 6} -> {0, 4, 8, 12}
#
# 実行環境: MARS / SPIM などの MIPS シミュレータ
#==============================================================

        .data
data:   .word   0, 2, 4, 6          # int data[] = {0, 2, 4, 6};

        .text
        .globl  main

#--------------------------------------------------------------
# int func(int a) { return a + a; }
#   引数  : $a0 = a
#   戻り値: $v0 = a + a
#--------------------------------------------------------------
func:
        add     $v0, $a0, $a0       # v0 = a + a
        jr      $ra                 # return v0

#--------------------------------------------------------------
# int main()
#--------------------------------------------------------------
main:
        addi    $sp, $sp, -4        # $ra を退避する領域を確保
        sw      $ra, 0($sp)

        li      $t0, 4              # num = 4
        la      $t1, data           # t1 = &data[0]
        li      $t2, 0              # i = 0

loop:
        slt     $t5, $t2, $t0       # t5 = (i < num) ? 1 : 0
        beq     $t5, $zero, end     # if (i >= num) goto end

        sll     $t3, $t2, 2         # t3 = i * 4 (word のバイトオフセット)
        add     $t4, $t1, $t3       # t4 = &data[i]
        lw      $a0, 0($t4)         # a0 = data[i]  (func の引数)

        jal     func                # func(data[i]) -> 結果は $v0

        sw      $v0, 0($t4)         # data[i] = func(data[i])

        addi    $t2, $t2, 1         # i++
        j       loop

end:
        lw      $ra, 0($sp)         # $ra を復元
        addi    $sp, $sp, 4

        li      $v0, 0              # return 0

        # --- シミュレータを正常終了させる (syscall 10: exit) ---
        li      $v0, 10
        syscall
