        ; 8080 assembler code
        .hexfile Sort.hex
        .binfile Sort.com
        ; try "hex" for downloading in hex format
        .download bin  
        .objcopy gobjcopy
        .postbuild echo "OK!"
        ;.nodump

    ; OS call list
PRINT_B     equ 1
PRINT_MEM   equ 2
READ_B      equ 3
READ_MEM    equ 4
PRINT_STR   equ 5
READ_STR    equ 6
GET_RND     equ 7

    ; Position for stack pointer
stack   equ 0F000h

    org 000H
    jmp begin

    ; Start of our Operating System
GTU_OS: PUSH D
    push D
    push H
    push psw
    nop ; This is where we run our OS in C++, see the CPU8080::isSystemCall()
        ; function for the detail.
    pop psw
    pop h
    pop d
    pop D
    ret
    ; ---------------------------------------------------------------
    ; YOU SHOULD NOT CHANGE ANYTHING ABOVE THIS LINE   


    ARRAY  DW 66H, 55H, 11H, 22H, 44H, 77H, 5CH, 6DH, 7CH, 12H, 0BAH, 0ABH, 0ACH, 0BBH, 0DBH, 0BCH, 0ADH, 0AEH, 62H, 0DCH, 0B1H, 7DH, 2FH, 0DEH, 0AAH, 
           DW 56H, 65H, 21H, 52H, 54H, 67H, 6CH, 5DH, 8CH, 29H, 0DDH, 0CBH, 0ECH, 0ABH, 0CBH, 0FCH, 0BDH, 0BDH, 92H, 0CCH, 0A1H, 3DH, 3FH, 0CDH, 0FFH, 34H
  
begin:
    LXI SP,stack    ; always initialize the stack pointer

START:

    LXI B, ARRAY    ; Load the starting address of the given array to (BC)
    MVI H, 0        ; Number of swap
    MVI L, 50       ; Number of items,counter   

LOOP:

    LDAX B          ; Load the first item from the (BC). A <- (BC)
    MOV D, A        ; D <­- A
    INX B           ; Double increment to pass the next index position
    INX B           ; Next array index   
    LDAX B          
    MOV E, A        ; E <­- A
    MOV A, D        ; A <­- D
    CMP E           ; Compare E and D
    JC CONTINUE     ; If the smaller or equal no swap operation
    JZ CONTINUE      
    INR H           ; Increment the swap number  

                    ; Swap Operation
    DCX B           ; Double decrement to next index position
    DCX B    
    MOV A, E        ; A <­- E
    STAX B          ; (BC) <­- A
    INX B           ; Double increment to next index position    
    INX B           ; BC <­ BC + 1 
    MOV A, D        ; A <­- D
    STAX B          ; (BC) <­- A
  

CONTINUE:

    DCR L           ; Decrement the size of array,counter 
    JNZ LOOP        ; Repeat loop until counter=0

    MVI A, 0        
    CMP H           ; Control the swap number. If it is not zero,return starting label
    JNZ START

    LXI D, ARRAY    ; DE <­ -  word
    MVI L, 51       ; Counter 

RESULT:

    LDAX D          ; Load the starting address of the given array to (DE)
    MOV B,A         ; B <­- A
    MVI A, PRINT_B  ; Call the system call
    call GTU_OS

    INX D           ; Double increment to pass the next index position
    INX D
    DCR L           ; Repeat loop until counter=0
    JNZ RESULT

    hlt             ; End program