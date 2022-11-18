// The code you must implement is provided in ISAproject.pdf

// Define stack start address
.stack 0x5000

// Define address of printf
.text 0x7000
.label printf

.data 0x100
.label ia
2
3
5
1
0
.label sia
50
43
100
-5
-10
50
0
.label sib
500
43
100
-5
-10
50
0
.label fmt1
.string //sia[%d]: %d
.label fmt2
.string //Something bad
.label fmt3
.string //cmp_arrays(sia, sib): %d
.label fmt4
.string //cmp_arrays(sia, sia): %d
.label fmt5
.string //cmp_arrays(ia, sib): %d
.label fmt6
.string //ia[%d]: %d
.label fmt7
.string //smallest(ia): %d
.label fmt8
.string //smallest(sia): %d
.label fmt9
.string //Nice sort and smallest
.label fmt10
.string //factorial(4) ia: %d
.label fmt11
.string //factorial(7) ia: %d
.label fmt12
.string //s1: %d, s2: %d
.text 0x300 
//sum_array DONE
// r0 has ia - address of null terminated array
// sum_array is a leaf function
// If you only use r0, r1, r2, r3; you do not need a stack

// implements this portion of the C code
// int sum_array(int *ia){		ia is r0
//	int s = 0;			r1 = s
//	while (*ia != 0){		cmp r1 to #0, if lessthan/= go to return
//		s += *ia;		add r1 to r2
//		ia++;			post increment to next item in array
//		}
//	return s;			return s
//	}
.label sum_array
//mov r0, 2          // hardcode to return a 2
ldr r1, [r0],#4      // stores ia[i] in r1, post increments after we store
cmp r1, #0	     // compares ia[i] to 0
bne sum_array_pt2 // if ia[i] != 0
bal sum_array_return
.label sum_array_pt2
add r2, r2, r1	     // adds r2 and r1, puts it in r2
bal sum_array	     // continues loop until ia[i] == 0
.label sum_array_return
mov r0, r2	   // puts r2 in r0 to return the sum
mov r2, #0         // resets r2 to 0
mov r1, #0         // moves 0 into r1
mov r15, r14       // return

.text 0x400 
//cmp_arrays
// r0 has ia1 - address of null terminated array
// r1 has ia1 - address of null terminated array
// cmp_arrays must allocate a stack
// Save lr on stack and allocate space for local vars
//
// implements this section of C code
// int cmp_arrays(int *ia1, int *ia2){
//	int s1 = sum_array(ia1);
//	int s2 = sum_array(ia2);
//	printf("s1: %d, s2: %d\n", s1, s2);
//	return s1 == s2 ? 0: (s1 > s2 ? 1 : -1);
//	}
.label cmp_arrays
//mov r0, #1
sbi sp, sp, 16     // Allocate stack, sp=r13
mva r5, r1
str lr, [r13,4]
blr sum_array	   // calls sumarray for ia1
mov r4, r0	   // puts answer into r5
//ldr lr, [r13,4]	   // moves address of ia2 into r0
mva r0, r5
mva r5, #0
blr sum_array	   // calls sum_array for ia2
mov r2, r4	   // puts result for first sum into r2
mov r3, r0	   // puts result of secondinto r3
//cmp r2, r3	   // compares r2 and r3, the two sum_array
// r1 is address of format string
// r2 is value of first %d
// r3 is value of second %d
mva r1, fmt12
ker #0x11
.label bp
cmp r2, r3
bne not_equals
//mva r0, fmt12	   // moves fmt12 into r0
//blr printf	   // printf(s1: %d, s2: %d)
mov r0, #0	   // puts 0 into r0 to return
blr skip_not
.label not_equals
mov r0, #-1	   // puts -1 into r0 to return
blr skip_not
.label skip_not
//add sp, sp, 16     // deallocates stack
mov r5, #0
mov r4, #0
mov r3, #0
mov r2, #0
mov r1, #0
ldr lr, [r13,4]
add sp, sp, 16
mov r15, r14       // return

.text 0x500 
//numelems DONE
// r0 has ia - address of null terminated array
// numelems is a leaf function
// If you only use r0, r1, r2, r3; you do not need a stack

// implements this section of C code
// int numelems(int *ia){
//	int c =   //my phone fell and deleted this code
//	while (*ia++ != 0)
//		c++;
//	return c;
//	}
.label numelems
//mov r0, 0xa        // hardcode to return a 10
ldr r1, [r0],#4      // stores ia[i] into r1, post increment 4
cmp r1, #0	     // compares r1 to number 0
ble numelems_final   // if it is equal to 0, send to final and end loop
add r2, r2, #1     // uncomment if we do not include last 0
bal numelems	     // else, continue loop
.label numelems_final
//mov r0, r2           // puts r2 into r0 to return the proper number
//mov r2, #0           // puts 0 into r2
mov r1, #0           // puts 0 into r1
bal break

.label break
mov r15, r14       // return

.text 0x600 
//sort
// r0 has ia - address of null terminated array
// sort must allocate a stack
// Save lr on stack and allocate space for local vars
//
// implements this C code
// void sort(int *ia){
//	int s = numelems
//	for (int i = 0; i < s; i++){   //loop
//		for (int j = 0; j < s-1-i; j++){//loop2
//			if (ia[j] > ia[j+1]){
//				int t = ia[j];
//				ia[j] = ia[j+1];
//				ia[j+1] = t;
//				} closes if loop
//			} closes inner for loop
//		} closes outer for loop
//	} ends function
.label sort			//dude next to me was saying something about checking if the beginning is 0
sbi sp, sp, 8     // Allocate stack
str r0,[r13,0]    //store beginning index
str lr,[r13,4]    //store link register
blr numelems       // count elements in ia[] count is currently in r2
ldr r0,[r13,0]     //restore r0 to the beginning index
ldr lr,[r13,4]     //restore link register
add sp, sp, 8	   //smallest reset
sbi sp, sp, 24     //allocate new stack
str r4, [r13, 0]   //will be used as i
mov r4, #0	   //int i = 0
str r5, [r13, 4]   //will be used as j
mov r5, #0	   //int j = 0
str r6, [r13, 8]   //will be used as temp
str lr, [r13, 12]  //store link ringister
//mov r0, [r13, 16]   //hopefully copies beginning index of r0 into that spot please do this 
str r7, [r13,20]    //used as s
.label loop        //begin nested loops
ldr r1, [r0],#4    // loads ia[i] into r1, post increment 4 lets r0 go to address of next item in ia
.label loop2

blt loop2
add r4, r4, #1        //i++
cmp r7, r4             //if i<size
bgt loop		//loop again
add sp, sp, 16		   // Deallocate stack
mov r15, r14       // return - sort is a void function

.text 0x700
// r0 has ia - address of null terminated array
// smallest must allocate a stack
// Save lr on stack and allocate space for local vars
//
// implements this C code
// int smallest(int *ia){
//	int s = numelems(ia);
//	int sm = *ia;
//	for (int *p = ia; p < ia+s; p++){
//		if (*p < sm){
//			sm = *p;
//		} closes if loop
//	} closes for loop
//	return sm;
//	} ends function
.label smallest
sbi sp, sp, 16     // Allocate stack, sb = r13
str r0, [r13]	//gusty add
str lr, [r13,4]//gusty add
blr numelems       // count elements in ia[]
//mov r0, r13	   // hopefully restores r0 to its first position
//ldr lr, [r13,4]//gusty add
mov r0, r13
//add sp, sp, 16	   // reallocates stack
mov r0, r13	   // hopefully restores r0 to first position
mov r3, r2	   // puts count into r3
ldr r1, [r0],#4
add r5, r5, #1	   // will technically be the first count
.label small_loop  // create loop to find smallest
ldr r2, [r0],#4		   // loads ia[i] into register 0, post increment #4
cmp r2, r1	   // of r1 < r2
bgt larger	   // branches to larger if r0 is greater than r1
mov r1, r2	   // put r0 into r1
.label larger
add r5, r5, #1     // starts count
cmp r5, r3         // if r2 < r3
blt small_loop
mov r2, #0	   // puts 0 in r2
mov r0, r1	   // puts the smallest value into r0
mov r1, #0
ldr lr, [r13,4]
add sp, sp, 16
mov r15, r14       // return

.text 0x800
// r0 has an integer
// factorial must allocate a stack
// Save lr on stack and allocate space for local vars
//
// implements this C code
// int factorial(int n){
//	if (n == 1){
//		return 1;
//	}
//	else{
//		return n * factorial(n-1);
//	}closes else
//	}closes funciton
.label factorial
  // implement algorithm
cmp r0, #1			//compare r0 to 1 (if(n==1))
beq fac_return
sub sp, sp, 16
str r0, [r13,#0]//store current val
str lr, [r13,#4]//store link reg
sub r0, r0, #1 //n-1
blr factorial    // factorial calls itself
.label fac_return
//X
ldr r1, [r13]   //store old val in r1
ldr lr, [r13,4] //recall link register
mul r0, r0, r1  //(n-1)*n yay commutative prop
add sp, sp, 16		   // Deallocate stack ||||this may need to go at spot labeled X||||
//mov r0, 120        // hardcode 5! as return value
mov r15, r14       // return

.text 0x900
// This sample main implements the following
// int main() {
//     int n = 0, l = 0, c = 0;
//     printf("Something bad");
//     for (int i = 0; i < 3; i++)
//         printf("ia[%d]: %d", i, sia[i]);
//     n = numelems(sia);
//     sm1 = smallest(sia);
//     cav =cmp_arrays(sia, sib);
// }
.label main
sbi sp, sp, 16     // allocate space for stack, sp = r13
                   // [sp,0] is int cav
                   // [sp,4] is int n
                   // [sp,8] is int sm1
str lr, [sp, 12]   // [sp,12] is lr (save lr)
mov r0, 0
str r0, [sp, 0]    // cav = 0;
str r0, [sp, 4]    // n = 0;
str r0, [sp, 8]    // sm1 = 0;
str r0, [sp, 12]   // sm2 = 0;
// printf("Something bad");
// Kernel call to printf expects parameters
// r1 - address of format string - "Something bad"
// mva r1, bad
// ker #0x11
// The os has code for printf at address 0x7000
// The code there generates the ker instruction
// You call printf with
// r0 - has address of format string - "Something bad"
mva r0, fmt2
blr printf
//
// for (int i = 0; i < 4; i++)
//     printf("ia[%d]: %d", i, sia[i]);
mov r4, 0          // i to r4
mva r5, sia   // address is sia to r5
.label loop4times  // print 3 elements if sia
cmp r4, 4
bge end_loop4times
// Kernel call to printf expects parameters
// r1 - address of format string - "ia[%d]: %d"
// r2 - value for first %d
// r3 - value for second %d
mva r1, fmt1       // fmt1 to r1
mov r2, r4         // i to r2
ldr r3, [r5], 4    // sia[i] to r3
ker #0x11          // Kernel call to printf
adi r4, r4, 1      // i++
bal loop4times

.label end_loop4times
// int n = numelems(sia);
mva r0, sia        // put address of sia in r0
.label num_break
blr numelems       // n = numelems(sia)
str r0, [sp, 4]
// int sm1 = smallest(sia);
mva r0, sia        // put address of sia in r0
//blr smallest       // sm1 = smallest(sia)
str r0, [sp, 8]    // store return value in sm1
// cav = cmp_arrays_sia, sib);
mva r0, sia        // put address of sia in r0
mva r1, sib        // put address of sib in r1
.label break_main
mov r2, #0
blr cmp_arrays
str r0, [sp, 0]
mva r0, fmt3	   // r1 is address of format string, r0 will 
blr printf	   // printf(cmp_arrays(sia, sib): %d)
mva r1, sia	   // put address of sia into r1
blr cmp_arrays
str r0, [sp,0]
mva r0, fmt4	   // printf("cmp_arrays(sia, sia): %d");
mva r0, sib        // puts sib into r0
mov r0, #4         // put 4 into sib[0]
blr cmp_arrays
str r0, [sp, 0]
mva r0, fmt3
blr printf	   // printf(cmp_arrays(sia, sib): %d);
mva r0, ia	   // puts ia into r0
mva r1, sib	   // puts sib into r1
blr cmp_arrays
str r0, [sp, 0]
mva r0, fmt5	   // printf(cmp_arrays(ia, sib):%d);
blr printf
mva r0, ia
//blr sort	   // sorts ia
blr numelems	   // numelems on r0, which should be ia
str r0, [sp, 4]    // stores numelems in n, which is sp, 4
mva r4, #0	   // emptying to use a counter
mva r5, ia
.label for_loop
cmp r4, r0
bge end_for_loop
mva r1, fmt6       // fmt6 to r1
mov r2, r4	   // i to r2
ldr r3, [r5], r0   // ia[i] to r3
ker #0x11	   // ker call to printf
adi r4, r4, 1	   // i++
bal for_loop
.label end_for_loop
mva r0, sia
//blr sort	   // sorts sia
blr numelems
str r0, [sp, 4]    // stores number of elements in sia in n
mva r4, #0 	   // silly counter
.label sec_for_loop
cmp r4, r0
bge end_sec_for_loop
mva r1, fmt1	   // stores fmt1 to r1
mov r2, r4	   // i to r2
ldr r3, [r5], r0   // ia[i] to r3
ker #0x11	   // ker call to printf
adi r4, r4, 1	   // i++
bal sec_for_loop
.label end_sec_for_loop
mva r0, ia
blr smallest	   // calls smallest on ia
str r0, [sp, 8]	   // stores in sm1
mva r0, sia	   // stores sia in r0
blr smallest       // calls smallest on sia
str r0, [sp, 12]   // stores in sm2
mva r0, fmt7
blr printf	   // printf(smallest(ia))
mva r0, fmt8
blr printf	   // printf(smallest(sia)
mva r0, ia	   // loads ia into r0
ldr r1, [r0,#0]	   // should be ia[0]
ldr r0, [sp, 8]	   // loads sm1 into r0
cmp r0, r1
bne some_bad
mva r0, fmt9
blr printf	   // printf(nice and smallest)
bal skip_bad
.label some_bad
mva r0, fmt2
blr printf	   // printf(something bad)
.label skip_bad
mva r0, sia        // loads sia into r0
ldr r1, [r0,#0]    // loads sia[0] into
ldr r0, [sp, 12]   // loads sm2 into r0
cmp r0, r1
bne some_bad_2
mva r0, fmt9
blr printf	   // printf(nice and smallest)
bal skip_bad_2
.label some_bad_2
mva r0, fmt2
blr printf	   // printf(something bad)
.label skip_bad_2
mva r0, #4
blr factorial
str r0, [sp, 4]
mva r0, fmt10
blr printf	   // printf(factorial(4))
mva r0, #7
blr factorial
str r0, [sp, 4]
mva r0, fmt11
blr printf	   // printf(factorial(7))
// Do not deallocate stack.
// This leaves r13 with an address that can be used to dump memory
// > d 0x4ff0 
// Shows the three hardcoded values stored in cav, n, and sm1.
// 0x4ff0 (0d20464) 0xffffffff 0x0000000a 0x00000002
.label end
bal end            // branch to self
