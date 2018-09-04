#include <iostream>
#include <fstream>
#include <string>
#include <cstdlib>     /* srand, rand */
#include <ctime>

#include "8080emuCPP.h"
#include "gtuos.h"

// Number of GTUOS systems calls
#define READ_B_NUMBER_OF_CYCLE     10;
#define PRINT_B_NUMBER_OF_CYCLE    10;

#define READ_MEM_NUMBER_OF_CYCLE   10;
#define PRINT_MEM_NUMBER_OF_CYCLE  10;

#define READ_STR_NUMBER_OF_CYCLE   100;
#define PRINT_STR_NUMBER_OF_CYCLE  100;

#define GET_RND_NUMBER_OF_CYCLE    5;


// Reads an integer from the keyboard and and puts it in register B.
// Returns the number of cycles
uint16_t GTUOS::read_b(const CPU8080 &cpu)
{  
    int userInput;

    std::cout << std::endl<< "READ_B is called"<<std::endl;
    //std::cout << "Enter an integer value to puts it in register B : ";

    std::cin>>userInput;
    cpu.state->b = userInput;
    
    return READ_B_NUMBER_OF_CYCLE;
}

// Prints the contents of register B on the screen as a decimal number.
// Returns the number of cycles
uint16_t GTUOS::print_b(const CPU8080 &cpu)
{
    std::cout << std::endl<< "PRINT_B is called" << std::endl;
    // std::cout << "Value of B" << cpu.state->b <<std::endl; 
    printf("Register B  : %d\n", cpu.state->b);

    return PRINT_B_NUMBER_OF_CYCLE;
}


// Reads an integer from the keyboard and puts it in the memory location pointed by registers B and C.
// Returns the number of cycles
uint16_t GTUOS::read_mem(const CPU8080 &cpu)
{ 

    //  8080emu.cpp line 423
    //  unsigned CPU8080::Emulate8080p(int debug) {}
    //  uint16_t offset=(state->b<<8) | state->c;

    // Register BC is equal to address
    uint16_t address = (cpu.state->b << 8) | cpu.state->c;
    std::cout << std::endl<< "READ_MEM is called"<<std::endl;
    std::cout << "Enter an integer value to puts it in the memory location : ";

    int userInput;
    std::cin>>userInput;


    cpu.memory->at(address) = userInput;
    
    return READ_MEM_NUMBER_OF_CYCLE;
}


// Prints the contents of the memory pointed by registers B and C as a decimal number.
// Returns the number of cycles
uint16_t GTUOS::print_mem(const CPU8080 &cpu)
{
    // Register BC is equal to address
    uint16_t address = (cpu.state->b << 8) | cpu.state->c;
    std::cout << std::endl<< "PRINT_MEM is called" << std::endl;
    


    std::cout<<"Register BC : " << (int)cpu.memory->at(address) << std::endl;


    return PRINT_MEM_NUMBER_OF_CYCLE;
}


// Reads the null terminated string from the keyboard and puts the result at the memory location pointed by B and C.
// Returns the number of cycles
uint16_t GTUOS::read_str(const CPU8080 &cpu)
{
    // Register BC is equal to address
    uint16_t address = (cpu.state->b << 8) | cpu.state->c;
    std::string userInput = "";

    std::cin.ignore(); // Ignore previous enter character
    std::cout<<std::endl<<"READ_STR is called"<<std::endl;
    std::cout<<"Enter a string to puts the result at the memory location : ";
    std::getline (std::cin, userInput);

    for(int i=0; i<userInput.length(); ++i)
    {
        

        cpu.memory->at(address) = userInput[i];
        ++address;
    }


    return READ_STR_NUMBER_OF_CYCLE;
}

// Prints the null terminated string at the memory location pointed by B and C.
// Returns the number of cycles
uint16_t GTUOS::print_str(const CPU8080 &cpu)
{
    // Register BC is equal to address
    uint16_t address = (cpu.state->b << 8) | cpu.state->c;
    std::cout<< std::endl<< "PRINT_STR is called"<<std::endl;



    while(cpu.memory->at(address) !='\0')
    {
        
        printf("%c",(char)cpu.memory->at(address));

        ++address;                      
    }

    return PRINT_STR_NUMBER_OF_CYCLE;
}


// Produces a random byte and puts in register B
// Returns the number of cycles
uint16_t GTUOS::get_rnd(const CPU8080 &cpu)
{    

    std::cout<< std::endl<< std::endl<<"GET_RND is called"<<std::endl;
  
    cpu.state->b = rand() % 256;
    printf("Register B  : %d\n", cpu.state->b);

    return GET_RND_NUMBER_OF_CYCLE;
}


// The whole memory is saved to exe.mem as a text file of hexedecimal numbers. 
// Each line of the file starts with the memory addres, then it
// shows 16 bytes of hexadecimal numbers separated with spaces.
void GTUOS::saveMemoryToFile(const CPU8080 & cpu)
{
    FILE *outputFile ;

    outputFile = fopen("exe.mem","w");                      // Open the file

    if(outputFile == NULL)                                  // Check the state of output file
    {
        fprintf(stderr, "Error : Output file could not opened !! \n");
        exit(1);
    }

    for(int address=0x0000; address<0xffff; address+=16)    // Memory address spaces
    {
        fprintf(outputFile, "%.4x:\t", address);

            for(int j=0; j<16; ++j)                         // Memory address space between 0 - F
            {
                fprintf(outputFile, "%.2x ",cpu.memory->physicalAt(address+j));    // Write memory contents to output file
            }

        fprintf(outputFile, "\n");
    }

    fclose(outputFile);                                     // Close the file

    std::cout<<std::endl<<"Whole memory contents are written to exe.mem file."<<std::endl;
  
}


// GTUOS systems calls handle function according to the Register A value.

/*  GTUOS call list

    PRINT_B     equ 1
    PRINT_MEM   equ 2
    READ_B      equ 3
    READ_MEM    equ 4
    PRINT_STR   equ 5
    READ_STR    equ 6
    GET_RND     equ 7
*/
uint64_t GTUOS::handleCall(const CPU8080 &cpu)
{
    uint16_t numberOfCycle=0;
     
    if(cpu.state->a == 1)
    {
        numberOfCycle = print_b(cpu);  
    }
    else if (cpu.state->a == 2)
    {
        numberOfCycle = print_mem(cpu);  
    }
    else if(cpu.state->a == 3)
    {
        numberOfCycle = read_b(cpu);
    }
    else if(cpu.state->a == 4)
    {
        numberOfCycle = read_mem(cpu); 
    }
    else if(cpu.state->a == 5)
    {
        numberOfCycle = print_str(cpu);
    }
    else if(cpu.state->a == 6)
    {
        numberOfCycle = read_str(cpu);  
    }
    else if(cpu.state->a == 7)
    {
        numberOfCycle = get_rnd(cpu); 
    }
    else {
        std::cout <<  "Unimplemented OS call";
        throw -1;
    }

    return numberOfCycle;
}













