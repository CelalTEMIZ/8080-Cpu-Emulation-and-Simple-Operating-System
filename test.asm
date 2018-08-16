        ; 8080 assembler code
        .hexfile test.hex
        .binfile test.com
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

    ; A file that tests each of the system calls one by one.  


openingMessage: DW '*** Welcome the 8080 CPU Emulation ***',00AH, 00H ; null terminated string
printB_Test1Message: DW 'PRINT_B immediate parameter test !!',00AH, 00H ; null terminated string
printB_Test2Message: DW 'PRINT_B user parameter test !!',00AH, 00H ; null terminated string


begin:
   
    ;----------------------------------------------------------------------------------------------------
    ; Prints the null terminated string at the memory location pointed by B and C.

    LXI B, openingMessage   ; put the address of string in registers B and C
    MVI A, PRINT_STR        ; store the OS call code to A
    call GTU_OS             ; call the OS

    ;----------------------------------------------------------------------------------------------------


    ;-----------------------------------------------------------------------------------------------------
    ; Prints the contents of register B on the screen as a decimal number.

    LXI B, printB_Test1Message  ; put the address of string in registers B and C
    MVI A, PRINT_STR            ; store the OS call code to A
    call GTU_OS                 ; call the OS

    MVI B, 9                    ; B = 9                  
    MVI A, PRINT_B              ; store the OS call code to A
    call GTU_OS                 ; call the OS

    ;-----------------------------------------------------------------------------------------------------


    ;------------------------------------------------------------------------------------------------------
    ; Reads an integer from the keyboard and and puts it in register B.

    LXI B, printB_Test2Message  ; put the address of string in registers B and C
    MVI A, PRINT_STR            ; store the OS call code to A
    call GTU_OS                 ; call the OS

    MVI A, READ_B               ; store the OS call code to A
    call GTU_OS                 ; call the OS

    ; Prints the contents of register B on the screen as a decimal number.

    MVI A, PRINT_B              ; store the OS call code to A
    call GTU_OS                 ; call the OS
    
    ;------------------------------------------------------------------------------------------------------


    ;-----------------------------------------------------------------------------------------------------
    ; Reads an integer from the keyboard and puts it in the memory location pointed by registers B and C.

    MVI A, READ_MEM             ; store the OS call code to A
    call GTU_OS                 ; call the OS
    
    ; Prints the contents of the memory pointed by registers B and C as a decimal number.
    
    MVI A, PRINT_MEM            ; store the OS call code to A
    call GTU_OS                 ; call the OS

    ;------------------------------------------------------------------------------------------------------
    

    ;---------------------------------------------------------------------------------------------------------------------
    ; Reads the null terminated string from the keyboard and puts the result at the memory location pointed by B and C.

    MVI A, READ_STR             ; store the OS call code to A
    call GTU_OS                 ; call the OS

    ; Prints the null terminated string at the memory location pointed by B and C.
    MVI A, PRINT_STR            ; store the OS call code to A
    call GTU_OS                 ; call the OS

    ;--------------------------------------------------------------------------------------------------------------------


    ;--------------------------------------------------------------------------------------------------------------------
    ; Produces a random byte and puts in register B.

    MVI A, GET_RND              ; store the OS call code to A
    call GTU_OS                 ; call the OS

    ; Prints the contents of register B on pointed by registers B and C as a decimal number.
    MVI A, PRINT_B              ; store the OS call code to A
    call GTU_OS                 ; call the OS

    ;--------------------------------------------------------------------------------------------------------------------

    hlt     ; end program