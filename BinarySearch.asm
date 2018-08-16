        ; 8080 assembler code
        .hexfile BinarySearch.hex
        .binfile BinarySearch.com
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
stack   equ 0F000H

    org 0000H
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

    ; my variables to use in searching
    ORG 8000H

ARRAY  DW 66H, 55H, 11H, 22H, 44H, 77H, 5CH, 6DH, 7CH, 12H, 0BAH, 0ABH, 0ACH, 0BBH, 0DBH, 0BCH, 0ADH, 0AEH, 62H, 0DCH, 0B1H, 7DH, 2FH, 0DEH, 0AAH, 
       DW 56H, 65H, 21H, 52H, 54H, 67H, 6CH, 5DH, 8CH, 29H, 0DDH, 0CBH, 0ECH, 0ABH, 0CBH, 0FCH, 0BDH, 0BDH, 92H, 0CCH, 0A1H, 3DH, 3FH, 0CDH, 0FFH, 34H

openingMessage:        DW '*** Welcome the 8080 CPU Emulation ***',00AH, 00H;
promptUserMessage:     DW 'Enter number',00AH, 00H;
ErrorMessage:          DW 'Error !',00AH,00H;


begin:

    LXI B, openingMessage   
    MVI A, PRINT_STR       
    call GTU_OS    


    LXI B, promptUser   
    MVI A, PRINT_STR       
    call GTU_OS          


    MVI A, READ_B
    call GTU_OS

    MVI H, 51
    LXI D, ARRAY
    MOV L, B

LOOP:

    LDAX D
    CMP L    
    JZ FOUND 
    INX D
    INX D
    DCR H
    JNZ LOOP

    LXI B, ErrorMessage   
    MVI A, PRINT_STR    
    call GTU_OS 

    JMP NOT_FOUND

FOUND: 

    MVI A, 51   
    SUB H      
    
    MOV B, A 
    MVI A, PRINT_B
    call GTU_OS
   
    
NOT_FOUND:    

    HLT  