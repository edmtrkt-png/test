# 演習課題: 以下の C 言語プログラムと同じ動きをする MIPS アセンブリ
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
# ※ 授業(第7回・第8回)で習った命令のみを使用する。
#   掛け算・シフト命令は未習のため、配列の要素には
#   ポインタ($s0)を 4 バイトずつ進めてアクセスする。

.data
num:    .word 4             # int num = 4;
data:   .word 0, 2, 4, 6    # int data[] = {0, 2, 4, 6};

.text
.globl main

main:
    # --- レジスタの退避 ($ra と使用する $s0,$s1,$s2 を保存) ---
    addi $sp $sp -16
    sw   $ra 0($sp)
    sw   $s0 4($sp)
    sw   $s1 8($sp)
    sw   $s2 12($sp)

    # --- 変数の準備 ---
    la   $s0 data           # $s0 = &data[0] (data[i] へのポインタ)
    la   $t0 num
    lw   $s1 0($t0)         # $s1 = num
    add  $s2 $zero $zero    # $s2 = i = 0

loop:
    slt  $t1 $s2 $s1        # $t1 = (i < num) ? 1 : 0
    beq  $t1 $zero end      # i < num でなければループ終了

    lw   $a0 0($s0)         # $a0 = data[i]   (関数の引数)
    jal  func               # func(data[i]) を呼び出し、結果は $v0
    sw   $v0 0($s0)         # data[i] = $v0

    addi $s0 $s0 4          # ポインタを次の要素へ (i++ に対応)
    addi $s2 $s2 1          # i = i + 1
    j    loop

end:
    # --- レジスタの復帰 ---
    lw   $ra 0($sp)
    lw   $s0 4($sp)
    lw   $s1 8($sp)
    lw   $s2 12($sp)
    addi $sp $sp 16
    jr   $ra

# int func(int a) { return a + a; }
func:
    add  $v0 $a0 $a0        # $v0 = a + a
    jr   $ra
