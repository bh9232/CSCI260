.data
frameBuffer:	.space	0x80000		#512 wide X 256 high pixels
m:		.word	256	
n:		.word 	128
c1r: 		.word 	0x00ff0000
c1g: 		.word  	0x0000ff00
c1b: 		.word 	0x000000ff
c2r: 		.word 	0x00ff0000
c2g: 		.word 	0x0000ff00
c2b: 		.word 	0x000000ff

.text
drawLine: la $t1,frameBuffer		#location of pixel pointer

counter:
li $t9,131072		#t9<-512*256
li $t8, 0		#t8<-0, counter for location of pixel
li $t7,0		#t7<-0, counter
li $t6,0		#t6<-0, counter

yellow:
li $t3,0x00ffff00	#t3<-yellow
sw $t3,0($t1)		#put color t3 in loaction t1
addi $t1,$t1,4		#t1<-t1+4
addi $t8,$t8,1		#t8<-t8+1
beq $t9,$t8,reset	#if done with yellow screen, goto reset
j yellow

reset:
addi  $t1,$t1,-4  	#t1<-t1-4
addi  $t8,$t8,-1 	#$t8<-t8-1
beq   $t8,0,green  	#if $t8 == 0 goto relocate
j reset            	#else goto reset

green:
li $t3,0x0000ff00	#t3<-green
sw $t3,131072($t1)	#put color t3 in loaction t1
addi $t1,$t1,4		#t1<-t1+4
addi $t8,$t8,1		#t8<-t8+1
beq $t9,$t8,end		#if done with yellow screen, goto reset
j green

end:
li $v0,10 		# exit code
syscall 		# exit to OS