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
.text 0x300
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
.label sum_array_breakpoint
//mov r0, 2          // hardcode to return a 2
ldr r1, [r0],#4      // stores ia[i] in r1, post increments after we store
cmp r1, #0	     // compares ia[i] to 0
ble sum_array_return // if ia[i] == 0, branches to return function
add r2, r2, r1	     // adds r2 and r1, puts it in r2
bal sum_array	     // continues loop until ia[i] == 0
.label sum_array_return
mov r0, r2	   // puts r2 in r0 to return the sum
mov r15, r14       // return

.text 0x400
// r0 has ia1 - address of null terminated array
// r1 has ia1 - address of null terminated array
// cmp_arrays must allocate a stack
// Save lr on stack and allocate space for local vars
.label cmp_arrays
                   // Allocate stack
                   // Call sum_array two times
mov r0, -1         // hardcode to return -1
		   // Deallocate stack
mov r15, r14       // return

.text 0x500
// r0 has ia - address of null terminated array
// numelems is a leaf function
// If you only use r0, r1, r2, r3; you do not need a stack

// implements this section of C code
// int numelems(int *ia){
//	int c = 0;
//	while (*ia++ != 0)
//		c++;
//	return c;
//	}
.label numelems
mov r0, 0xa        // hardcode to return a 10
.label break
mov r15, r14       // return

.text 0x600
// r0 has ia - address of null terminated array
// sort must allocate a stack
// Save lr on stack and allocate space for local vars
.label sort
                   // Allocate stack
// blr numelems    // count elements in ia[]
                   // create nested loops to sort
		   // Deallocate stack
mov r15, r14       // return - sort is a void function

.text 0x700
// r0 has ia - address of null terminated array
// smallest must allocate a stack
// Save lr on stack and allocate space for local vars
.label smallest
                   // Allocate stack
// blr numelems    // count elements in ia[]
                   // create loop to find smallest
mov r0, 2          // hardcode to return a 2
		   // Deallocate stack
mov r15, r14       // return

.text 0x800
// r0 has an integer
// factorial must allocate a stack
// Save lr on stack and allocate space for local vars
.label factorial
                   // Allocate stack
		   // implement algorithm
//blr factorial    // factorial calls itself
		   // Deallocate stack
mov r0, 120        // hardcode 5! as return value
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
//     cav = cmp_arrays(sia, sib);
// }
.label main
// int ia[] = {1,2,3,4}				// silly little test code to test functions
//sub r13, r13, #24
//mov r2, #1
//str r2, [r13, #0] // ia[0] = 1
//mov r2, #2
//str r2, [r13, #4] // ia[1] = 2
//mov r2, #3
//str r2, [r13, #8] // ia[2] = 3
//mov r2, #4
//str r2, [r13, #12]// ia[3] = 4
//mov r2, #0
//str r2, [r13, #40]
//str r14, [r13, #44]
//mov r0, r13
//mov r3, #10 // "size" of array		// end of my silly little test code
//bal sum_array
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
blr numelems       // n = numelems(sia)
str r0, [sp, 4]
// int sm1 = smallest(sia);
mva r0, sia        // put address of sia in r0
blr smallest       // sm1 = smallest(sia)
str r0, [sp, 8]    // store return value in sm1
// cav = cmp_arrays_sia, sib);
mva r0, sia        // put address of sia in r0
mva r1, sib        // put address of sib in r1
blr cmp_arrays
str r0, [sp, 0]
// Do not deallocate stack.
// This leaves r13 with an address that can be used to dump memory
// > d 0x4ff0 
// Shows the three hardcoded values stored in cav, n, and sm1.
// 0x4ff0 (0d20464) 0xffffffff 0x0000000a 0x00000002
.label end
bal end            // branch to self
