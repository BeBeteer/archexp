label_0:
lw $1, 84($0)
add $2, $1, $1
label_2:
sub $3, $1, $2
beq $1, $1, label_2
andi $4, $2, 0
addi $5, $4, 1
ori $6, $3, 0
bne $6, $3, label_2
lw $7, 80($0)
sw $7, 84($0)
addi $8, $7, 1
j label_0
andi $9, $8, 1
