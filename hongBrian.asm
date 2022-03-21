.data
frameBuffer:	.space	0x80000		#512 wide X 256 high pixels
m:		.word	80		#size of inner square	
n:		.word 	120		#size of outer square
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
#green color setup
la $t1,c2r		#t1<-c2r
lw $t1,c2r		#t1<-value of c2r
la $t2,c2g		#t2<-c2g
lw $t2,c2g		#t2<-value of c2g
la $t3,c2b		#t3<-c2b
lw $t3,c2b		#t3<-value of c2b
add $s2,$t1,$t2		#s2<-t1+t2
add $s2,$s2,$t3		#s2<-s2+t3, green
#red color setup
la $t1,c1r		#t1<-c1r
lw $t1,c1r		#t1<-value of c1r
la $t2,c1g		#t2<-c2g
lw $t2,c1g		#t2<-value of c1g
la $t3,c1b		#t3<-c2b
lw $t3,c1b		#t3<-value of c1b
add $s3,$t1,$t2		#s3<-t1+t2
add $s3,$s3,$t3		#s3<-s3+t3, red
#reset temps
sub $t1,$t1,$t1
sub $t2,$t2,$t2
sub $t3,$t3,$t3
#counters
li $t9,131072		#t9<-512*256
li $t8,0		#t8<-0, counter for location of pixel

yellow:
li $t1,0x00FFFF00 	#t3<-yellow
sw $t1,0($t0)		#put color t1 in loaction t0
addi $t0,$t0,4		#t1<-t1+4
addi $t8,$t8,1		#t8<-t8+1
bne $t8,$t9,yellow	#if t8!=t9 (if counter is not at last pixel of screen), goto yellow

check:
#reset
sub $t9,$t9,$t9		#t9<-0
sub $t8,$t8,$t8		#t8<-0
#if m is odd
andi $t1,$s0,1		#t1<-1 if m is odd; else t1<-0
beq $t1,1,end		#if m is odd, goto end (cannot be cetnered so impossible)
#if m>256
slti $t1,$s0,257	#t1<-1 if m<257; else t1<-0
beq $t1,0,end 		#if m>256, square too large for bitmap of 512*256 so impossible
#if n is odd
andi $t1,$s1,1		#t1<-1 if n is odd; else t1<-0
beq $t1,1,end		#if n is odd, goto end (cannot be cetnered so impossible)
#if n>256
slti $t1,$s1,257	#t1<-1 if n<257; else t1<-0
beq $t1,0,end 		#if n>256, square too large for bitmap of 512*256 so impossible
#if m>n
slt $t1,$s0,$s1		#t1<-1 if m<n; else t1<-0
beq $t1,0,end		#if m>n, goto end since impossible to create

#outer square setup
addi $t8,$zero,128	#half of total rows
addi $t9,$zero,256	#half of total columns
#get starting point of outer square
la $t0,frameBuffer	#reset position of pixel pointer
srl $t1,$s1,1		#t1<-n/2
sub $t2,$t8,$t1		#t2<-128-n/2
sll $t2, $t2, 11	#t2<-t2*2^11 (128-n/2*2048), offset for one row
sub $t3,$t9,$t1		#t3<-256-n/2
sll $t3,$t3,2		#t3<-t3*4, offset for one pixel
add $t2,$t2,$t3		#t2<-t2+t3, offset for start point of outer square
add $t0,$t0,$t2		#set pixel pointer to start point of outer square
#get ending point of outer square
add $t1,$s1,$zero	#t1<-n
sll $t1,$t1,2		#t1<-t1*4
addi $t8,$zero,2048	#t8<-2048
sub $t1,$t8,$t1		#t1<-2048-t1, distance between end point and next start point
#counter
sub $t8,$t8,$t8		#t8<-0
sub $t9,$t9,$t9		#t9<-0

outer:
sw $s2,0($t0)		#put color s2 at position t0
addi $t0,$t0,4		#t0<-t0+4, next pixel
addi $t8,$t8,1		#$t8<-$t8+1
bne $t8,$s1,outer	#goto outer if t8!=n
add $t8,$zero,$zero	#$t8<-0
add $t0,$t0,$t1		#t0<-t0+t1, move pixel pointer to next starting point
addi $t9,$t9,1		#$t9<-$t9+1
bne $t9,$s1,outer	#goto outer if t7!=n

#reset for inner square
addi $t8,$zero,128	#half of total rows
addi $t9,$zero,256	#half of total columns
#get starting point of inner square
la $t0,frameBuffer	#reset position of pixel pointer
srl $t1,$s0,1		#t1<-m/2
sub $t2,$t8,$t1		#t2<-128-m/2
sll $t2, $t2, 11	#t2<-t2*2^11 (128-n/2*2048), offset for one row
sub $t3,$t9,$t1		#t3<-256-m/2
sll $t3,$t3,2		#t3<-t3*4, offset for one pixel
add $t2,$t2,$t3		#t2<-t2+t3, offset for start point of inner square
add $t0,$t0,$t2		#set pixel pointer to start point of inner square
#get ending point of outer square
add $t1,$s0,$zero	#t1<-m
sll $t1,$t1,2		#t1<-t1*4
addi $t8,$zero,2048	#t8<-2048
sub $t1,$t8,$t1		#t1<-2048-t1, distance between end point and next start point
#counter
sub $t8,$t8,$t8		#t8<-0
sub $t9,$t9,$t9		#t9<-0

inner:
sw $s3,0($t0)		#put color s3 at position t0
addi $t0,$t0,4		#t0<-t0+4, next pixel
addi $t8,$t8,1		#$t8<-$t8+1
bne $t8,$s0,inner	#goto outer if t8!=m
add $t8,$zero,$zero	#$t8<-0
add $t0,$t0,$t1		#t0<-t0+t1, move pixel pointer to next starting point
addi $t9,$t9,1		#$t9<-$t9+1
bne $t9,$s0,inner	#goto outer if t7!=m

#setup for top diagonals
#start pos for top diagonals
li $t1,0x0		#t1<-color black
la $t0,frameBuffer	#reset pixel pointer
addi $t8,$zero,128	#half of total rows
addi $t9,$zero,256	#half of total columns

srl $t2,$s1,1		#t2<-n/2
sub $t3,$t8,$t2		#t3<-128-n/2
sll $t3,$t3,11		#t3<-t3*2^11 (t3*2048), offset for one row
sub $t4,$t9,$t2		#t4<-256-n/2
sll $t4,$t4,2		#t4<-t4*4, offset for one pixel 
add $t3,$t3,$t4		#t3<-t3+t4, offset for start point of outer square
add $t0,$t0,$t3		#set pixel pointer to t3
#counters
add $t7,$zero,$zero	#t7<-0
sub $t6,$s1,$s0		#t6<-n-m
srl $t6,$t6,1		#t6<-t6/2

topDiagonal:
sw $t1,0($t0)		#put color black in location t0
sll $t2,$s1,2		#t2<-n*4
sll $t3,$t7,3		#t2<-t7*2^3, t2<-t7*8
sub $t2,$t2,$t3		#t2<-t2-t3
addi $t2,$t2,-4		#t2<-t2-4
add $t0,$t0,$t2		#set t0 to top pixel of top right diagonal
sw $t1,0($t0)		#put color black in location t0

addi $t2,$t2,-4		#t2<-t2-4
addi $t3,$zero,2048	#t3<-2048
sub $t2,$t3,$t2		#t2<-2048-t2, distance between diagonals on next line
add $t0,$t0,$t2		#set t0 to pixel of top left diagonal on next line
addi $t7,$t7,1		#t7<-t7+1, counter
bne $t7,$t6,topDiagonal	#if t7!=(n-m), goto topDiagonal

#setup for bottom diagonals (botDiagonal)
#start pos of bot diagonals
la $t0,frameBuffer	#reset pixel pointer
srl $t2,$s0,1		#t2<-m/2
add $t3,$t8,$t2		#t3<-128+m/2
sll $t3,$t3,11		#t3<-t3*2048
sub $t2,$t9,$t2		#t2<-256-m/2
sll $t2,$t2,2		#t2<-t2*4
add $t3,$t3,$t2		#t3<-t3+t2
add $t0,$t0,$t3		#set t0 to 1 pixel right of bottom left diagonal
addi $t0,$t0,-4		#set t0 to top pixel of bottom left diagonal
#coutners
add $t7,$zero,$zero	#t7<-0
sub $t6,$s1,$s0		#t6<-n-m
srl $t6,$t6,1		#t6<-t6/2

botDiagonal:
sw $t1,0($t0)		#put color black in location t0
sll $t2,$t7,3		#t2<-t7*2^3, t2<-t7*8
sll $t3,$s0,2		#t3<-m*4
add $t2,$t2,$t3		#t2<-t2+t3
addi $t2,$t2,4		#t2<-t2+4
add $t0,$t0,$t2		#set t0 to top pixel of bottom right diagonal
sw $t1,0($t0)		#put color black in location t0

sll $t2,$t7,3		#t2<-t7*8
add $t2,$t2,$t3		#t2<-t2+t3
addi $t3,$zero,2048	#t3<-2048
sub $t2,$t3,$t2		#t3<-2048-t2
add $t0,$t0,$t2		#set t0 to pixel of bottom left diagonal of next line
addi $t0,$t0,-8		#set t0 to pixel of bottom left diagonal of next line
#counters
addi $t7,$t7,1		#t7<-t7+1
bne $t7,$t6,botDiagonal	#if t7!=(n-m), goto to botDiagonal

end:
li $v0,10 		# exit code
syscall 		# exit to OS