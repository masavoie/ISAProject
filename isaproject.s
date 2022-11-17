// The code you must implement is provided in ISAproject.pdf

// Define stack start address
.stack 0x5000

// Define address of printf
.text 0x7000
.label printf

.data 0x100
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
.string //cmp_arrays(ia, sia): %d
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
ble sum_array_return // if ia[i] == 0, branches to return function
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
blr sum_array	   // first call to sum_array for the first array // call sum_array two times
mov r3, r0	   // puts answer of sum_array into r3, this will be our s1
mov r0, r1	   // put second array into r0
blr sum_array      // second call to sum_array for second array
mov r1, r3
cmp r0, r1
beq cmp_equals     // if equal branch to .equals label
bne cmp_not_equal  // else branch to this one instead
.label cmp_equals
mov r0, 1          // puts 1 into r0 to return 1, or that they are equal
bal cmp_return     // skips the cmp_not_equal
.label cmp_not_equal
mov r0, -1         // hardcode to return -1 for not equal
add sp, sp, 16	   // Deallocate stack by adding the values back to sp
.label cmp_return
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
sbi sp, sp, 16     // Allocate stack
blr numelems       // count elements in ia[] count is currently in r2
add sp, sp, 16	   //smallest reset
sbi sp, sp 16
mov r0, r13 	   //reset r0 to beginning of ia[]
.label loop        //begin nested loops
ldr r1, [r0],#4    // loads ia[i] into r1, post increment 4
.label loop2

sub r2, r2, #1        //size= size-1
cmp r2, #0             //if size > 0
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
ldr lr, [r13,4]//gusty add
mov r0, [r13]


add sp, sp, 16	   // reallocates stack
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

// needs to implement the following:
//	sib[0] = 4;
//	cav = cmp_arrays(sia, sia);
//	printf("cmp_arrays(sia, sia): %d\n", cav);	fmt4
//	cav = cmp_arrays(ia, sib);
//	printf("cmp_arrays(ia, sia): %d\n", cav);	fmt5
//	sort(ia);
//	n = numelemss(ia);
//	for (int i = 0; i < n ; i++){
//		printf("ia[%d]: %d\n", 1, sia[i]);	fmt6
//	}
//	sm1 = smallest(ia);
//	sm2 = smallest(sia);
//	printf("smallest(ia): %d\n", sm1);		fmt7
//	printf("smallest(sia): %d\n", sm2);		fmt8
//	if (sm1 != ia[0]){
//		printf("Something bad\n");		fmt2
//	}else{
//		printf("Nice sort and smallest\n");	fmt9
//	}if(sm2 != sia[0]){
//		printf("Something bad\n");		fmt2
//	}else{
//		printf("Nice sort and smallest\n");	fmt9
//	}
//	n = factorial(4);
//	printf("factorial(4) ia: %d\n", n);		fmt10
//	n = factorial(7);
//	printf("factorial(7) ia: %d\n", n);		fmt10
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
blr cmp_arrays
str r0, [sp, 0]
mva r0, fmt3	   // r1 is address of format string, r0 will 
blr printf	   // printf(cmp_arrays(sia, sib): %d)

// Do not deallocate stack.
// This leaves r13 with an address that can be used to dump memory
// > d 0x4ff0 
// Shows the three hardcoded values stored in cav, n, and sm1.
// 0x4ff0 (0d20464) 0xffffffff 0x0000000a 0x00000002
.label end
bal end            // branch to self
