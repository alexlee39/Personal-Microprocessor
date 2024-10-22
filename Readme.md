# CSE141L Project
I have 3 different assembly scripts for each program, assembly1.txt,assembly2.txt,assembly3.txt
You need to compile them into machine code by runnning assembly.py which is my assembler
This would convert the assembly to machine code in 3 different files: prog1.txt, prog2.txt, prog3.txt

There is no difference in the test_bench files besides from changing variable names of top_level design but I 
have included also it in the grade submission.

To run the code just simply compile all the .sv files aside from the other test_bench .sv files included and make
sure your instr_rom.sv file is reading the correct machine code text file(ie: prog1.txt, prog2.txt, prog3.txt)

[FEC](https://www.youtube.com/watch?app=desktop&v=t4kiy4Dsx5Y)

Program 1: Detects Parity Bits and if parity bits are calculated correctly

Program 2: Detects FEC Error Correction when inserted no errors, 1 bit errors, and 2 bit errors. 

Program 3: Specifies a certain 5 bit pattern(Waldo). Given an 8 bit pattern that is repeated 32 times, track how many times the (Waldo) pattern appears per line without
byte crossing, how many times