.data
frameBuffer:	.space	0x80000		#512 wide X 256 high pixels
m:		.word	256	
n:		.word 	128
c1r: 		.word 	0x00FF00
c1g: 		.word  	0x00FF00
c1b: 		.word 	0x00FF00
c2r: 		.word 	0x00FF00
c2g: 		.word 	0x00FF00
c2b: 		.word 	0x00FF00

.text
drawLine: la $t1,frameBuffer
li $t3,0x0000FF00	# $t3 ? green
sw $t3,15340($t1)
sw $t3,15344($t1)
sw $t3,15348($t1)
sw $t3,15352($t1)
sw $t3,15356($t1)
sw $t3,15360($t1)
sw $t3,15364($t1)
sw $t3,15368($t1)
sw $t3,15372($t1)
sw $t3,15376($t1)
li $v0,10 		# exit code
syscall 		# exit to OS