#ifndef H_GTUOS
#define H_GTUOS

#include "8080emuCPP.h"

// GTUOS Class

class GTUOS{

	public:
		// System calls handle function
		uint64_t handleCall(const CPU8080 & cpu);
		// Save the whole memory content to exe.mem file
		void saveMemoryToFile(const CPU8080 & cpu);
		
	private:

		// Reads an integer from the keyboard and and puts it in register B.
		uint16_t read_b(const CPU8080 & cpu);
		// Prints the contents of register B on pointed by registers B and C as a decimal number.
		uint16_t print_b(const CPU8080 & cpu);

		
		//Reads an integer from the keyboard and puts it in the memory location pointed by registers B and C.
		uint16_t read_mem(const CPU8080 & cpu);
		// Prints the contents of the memory pointed by registers B and C as a decimal number.
		uint16_t print_mem(const CPU8080 & cpu);
		
		
		// Reads the null terminated string from the keyboard and puts the result at the memory location pointed by B and C.
		uint16_t read_str(const CPU8080 & cpu);
		// Prints the null terminated string at the memory location pointed by B and C.
		uint16_t print_str(const CPU8080 & cpu);


		// Produces a random byte and puts in register B
		uint16_t get_rnd(const CPU8080 & cpu);
	

};

#endif