/*

	CELAL TEMIZ - 101044070

	CSE 312 	- Operating Systems	-	HW01
	
	8080 CPU Emulation and Simple OS

	Assembler to produce the executable machine code for emulator. 
	Use the simple assembler at , http://asdasd.rpg.fi/~svo/i8080/ which helps a lot in writing the assembly
	code. You can directly download the executable .com file from this site with some browsers.

	Compile   : make buildemulator 
	Run 	  : ./emulator.out exe.com debugFlag

*/


#include <iostream>
#include "8080emuCPP.h"
#include "gtuos.h"
#include "memory.h"	


int main (int argc, char**argv)
{

  	srand (time(NULL));

	if (argc != 3){
		std::cerr << "Usage: prog exeFile debugOption\n";
		exit(1); 
	}

	int DEBUG = atoi(argv[2]);

	memory mem;
	CPU8080 theCPU(&mem);
	GTUOS	theOS;

	// Number of cycles
    uint16_t numberOfCycles = 0; 

	theCPU.ReadFileIntoMemoryAt(argv[1], 0x0000);	

	do	
	{
        numberOfCycles += theCPU.Emulate8080p(DEBUG);		// Calculate number of cycles

		if(theCPU.isSystemCall())
            numberOfCycles += theOS.handleCall(theCPU); 	// Add number of system call cycles

       
		// Simulation waits for an input ( ENTER ) from the keyboard and it continues for the next tick.
		// After each instruction execution, the CPU state is displayed.

        if (DEBUG == 2)
            std::cin.get();									

	}	while (!theCPU.isHalted());

	
	theOS.saveMemoryToFile(theCPU); // Save the whole memory to exe.mem
 
    std::cout<<std::endl<<"Total Number of Cycles : " << numberOfCycles<<std::endl<<std::endl;

	return 0;
}
