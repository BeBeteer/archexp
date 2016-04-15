lw $1, 80($0)
lw $6, 81($0)
label_0:
add $3, $0, $0
add $4, $0, $0
add $5, $0, $0
add $2, $2, $1
sub $3, $3, $1
and $4, $4, $1
nor $5, $5, $1
beq $2, $1, label_0
