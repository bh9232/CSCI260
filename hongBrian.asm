.data
frameBuffer:	.space	0x80000		#512 wide X 256 high pixels
m:		.word	256	
n:		.word 	128
c1r: 		.word 	0x00ff0000
c1g: 		.word  	0x0
c1b: 		.word 	0x0
c2r: 		.word 	0x0
c2g: 		.word 	0x0000ff00
c2b: 		.word 	0x0

.text
drawLine: la $t0,frameBuffer		#location of pixel pointer

#alloc
la $s0,m		#s0<-addr of m
lw $s0,0($s0)		#s0<-m
la $s1,n 		#s1<-addr of n
lw $s1,0($s1)		#s1<-n

color:
la $t1,c2r		#t1<-c2r
la $t2,c2g		#t1<-c2g
la $t3,c2b		#t1<-c2b
add $s2,$t1,$t2		#s2<-t1+t2
add $s2,$s2,$t3		#s2<-s2+t3, green
la $t1,c1r		#t1<-c1r
la $t2,c1g		#t2<-c1g
la $t3,c1b		#t3<-c1b
add $s3,$t1,$t2		#s2<-t1+t2
add $s3,$s2,$t3		#s2<-s2+t3, red

counter:
li $t9,131072		#t9<-512*256
li $t8,0		#t8<-0, counter for location of pixel

yellow:
li $t1,0x00ffff00	#t3<-yellow
sw $t3,0($t0)		#put color t3 in loaction t1
addi $t1,$t0,4		#t1<-t1+4
addi $t8,$t8,1		#t8<-t8+1
beq $t9,$t8,reset	#if done with yellow screen, goto reset
j yellow

reset:
addi  $t0,$t0,-4  	#t1<-t1-4
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
