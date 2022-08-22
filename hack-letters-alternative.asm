// Author: Simon Biel

// Idea: Use 3 Ram slots per char to save which pixel needs to be black
// A character can be max. 5 "Blocks" wide and 5 "Blocks" high
// A Block is just 16x16 pixels to keep it more simple

// 1. Ram address: 10 lsf -> 2 rows || 3 next bits -> used to save width of character
// 2. Ram adderss: 15 lsf -> 3 more rows

// Used variables:
// R0 -> Save current position on the screen. There the next character will be written to
// R1 -> Save programm address where a called 'function' will jump back to once executed.
// R2 -> Used for naming the column where a block shall be written when calling 'PAINT'
// R3 -> Used for naming the row where a block shall be written when calling 'PAINT'
// R4 -> Used for modulo: R4 % R5 = R6
// R5 -> Used for modulo: R4 % R5 = R6
// R6 -> Used for modulo: R4 % R5 = R6


// Process of saving the letter patterns:
// generally starting at Ram[11000]
// ASCII-code of the letter multiplied by 2 = first Ram slot
// e.g. for 'A' = 65 -> Ram[11000+2*65] = RAM[11130] || RAM[11131] then is the second slot 'belonging' to A

// INITIALIZATION || Example given for A


// A
// First Ram Slot: Width = 3 || Pixel 1 written in line 0 || pixel 0 & 2 written in line 1
// Binary Values (Except for the ones which show the width) need to be read backwards in order to see which block is painted black
// Value in binary:    000|011|00101|00010
@3234 // Decimal representation of above binary number
D=A
@11130
M=D 
// Second Ram Slot: Pixel 0&2 in Line 2 || Pixel 0&1&2 in Line 3 || Pixel 0&2 in Line 4
// 0|00101|00111|00101
@5349
D=A
@11131
M=D

// B

// C

// D

// E

// F

// G

// H

// I

// J

// K

// L

// M

// N

// O

// P

// Q

// R

// S

// T

// U

// V

// W

// X

// Y

// Z


(RESET)
@SCREEN
D=A
@R0 // Save screen position in R0
M=D
@rowStartingPoint // Save starting point of current row
M=D
@lettersInRow // Save Number of Blocks in line || Max 27 until new char is written to next line
M=0
@currentRow
M=0
@saveCharacterWidth
M=0
(RESETLOOP)
@R0
A=M
M=0
@R0
M=M+1
@KBD
D=A
@R0
D=D-M
@RESETLOOP
D;JNE
@SCREEN
D=A
@R0
M=D


(WAITLOOP)  
@KBD
D=M
@WAITLOOP
D;JEQ
@SAVEKEY
M=D
(WAITFORRELEASE)
@SAVEKEY
D=M
@KBD
D=D-M
@WAITFORRELEASE
D;JEQ


(WRITEKEY)
// Add these to finish-painting-function
@saveRepresentationStartingPoint
M=0
@saveCharacterWidth
M=0


// Compute Starting Address of Ram slots prividing the letters representation
@SAVEKEY
D=M
A=D
D=D+A // compute 2*D = 2*ASCII-code
@11000
D=D+A // Add 11000 to get starting Ram address of instructions for writing the letter

/////////
// here: save where the representation of the character starts in ram
// & save the width of the character
/////////


// First get the width
// important bits are -> 2^11 | 2^12 | 2^13
@saveRepresentationStartingPoint 
M=D // save address of first ram slot
A=M
D=M
@1024
D=D&A
D=D-A // If bit 2^11 is 1 -> D is now 0
@ADD.ONE
D;JEQ // Add 1 to width
(WRITE.ANKER.1)
@saveRepresentationStartingPoint 
A=M
D=M // get value of first ram slot
@2048
D=D&A
D=D-A // If bit 2^12 is 1 -> D is now 0
@ADD.TWO
D;JEQ // Add 2 to width
(WRITE.ANKER.2)
@saveRepresentationStartingPoint 
A=M
D=M // get value of first ram slot
@4096
D=D&A
D=D-A // If bit 2^13 is 1 -> D is now 0
@ADD.FOUR
D;JEQ // Add 4 to width
(WRITE.ANKER.3)

@WRITEKEY.PAINT
0;JMP


(ADD.ONE)
@saveCharacterWidth
M=M+1
@WRITE.ANKER.1
0;JMP

(ADD.TWO)
@2
D=A
@saveCharacterWidth
M=M+D
@WRITE.ANKER.2
0;JMP

(ADD.FOUR)
@4
D=A
@saveCharacterWidth
M=M+D
@WRITE.ANKER.3
0;JMP


/////////////////////
// now: start with painting
// how it works: Check for each bit individually using the '&' operator
// with this technique, loop over all relevant bits
//
// notation of the comments: x|y = column | line
// column -> starting from the left
// line -> starting from the top
/////////////////////
// R2 -> Used for naming the column where a block shall be written when calling 'PAINT'
// R3 -> Used for naming the row where a block shall be written when calling 'PAINT'
/////////////////////

(WRITEKEY.PAINT)
@currentBit // used for saving the value of the current bit to check for 0 or 1
M=1
@R2 // start at column 0
M=0
@R3 // start at row 0
M=0

(WRITEKEY.PAINT.LOOP)
@WRITEKEY.PAINT.LOOP.ANCHOR
D=A
@R1
M=D // Save position to jump eventually back to
@currentBit
D=M
@saveRepresentationStartingPoint
A=M
D=M&D // 'get' relevant bit
@currentBit
D=D-M // If bit was set -> D is now 0
@PAINT
D;JEQ
(WRITEKEY.PAINT.LOOP.ANCHOR)
@currentBit
D=M
M=D+M // Double the value -> shift the bit one to the left

(WRITEKEY.PAINT.INCREMENT.COUNTERS)
///////
// If Row = 0 && Bit 10 was checked -> increase row and set currentBit to 1 again
@currentBit
D=M
@R3
D=D+M // D = Row + currentBit
@1024 //2^10
D=D-A // If 10 bits (2^0-2^9) were painted already, currentBit is now 2^10 and thus, D would now be 0 if we are in Row 0
@WRITEKEY.GOTO.SECONDLINE
D;JEQ // If not all bits in first row checked -> loop again over next Bit

///////
// Else if Row = 1 && Bit 15 was checked -> Jump back to input-polling loop.
@currentBit // If Bit 16 was checked -> currentBit would be -32768 due to integer overflow
D=M
@R3
D=D+M
@32767
D=D+A // -32768 +1 +32767 = 0 -> given, if last Bit checked
@WAITLOOP
D;JEQ ///////////// HERE: MOVING CURSOR MUST BE IMPLEMENTED

///////
// Else -> Column ++
@R2
M=M+1

@WRITEKEY.PAINT.LOOP
0;JMP







(WRITEKEY.GOTO.SECONDLINE)
@R3
M=1 // Second line
@R2
M=0 // First column
@WRITEKEY.PAINT.LOOP
0;JMP





////////////
// Functions to write blocks of a specific Line begin here
////////////

// From Current position (R0): Draw a 16x16 Black Rectangle -> 16 to the right and 16 downwards
// Then go Back to the starting position
// Jump back to the line given in R1
(WRITE.0)
@R0
D=M // Current Position written to D
@c // Tmp position pointer
M=D
(WRITEBLOCKLOOP) // Loop over 16 screen rows
@c
A=M
M=-1
@512
D=A
// Check for c - R0 = 16
@c
D=D-M
@R0
D=D+M // D should be 16 if last line reached
       // If last Line was written to -> now is 0
@R1
A=M
D;JEQ // Jump back to calling function
@32
D=A
@c
M=M+D // else c+32 & Loop again
@WRITEBLOCKLOOP
0;JMP

// Write second Block starting from R0 -> 16x16 black rectangle but starting 16 pixels to the right. Then go back to starting position
// Jump back to the line given in R1
(WRITE.1)
@R0
D=M
@tmp
M=D // Save starting position
@R0
M=M+1
@R1
D=M
@tmpLine
M=D // Save Line to Jump back to
@WRITE.1.END
D=A
@R1
M=D // Line for "WRITEBLOCk" to jump back to
@WRITE.0
0;JMP // Write the Block
(WRITE.1.END)
@tmp
D=M
@R0
M=D // Write initial screen starting position back to R0
@tmpLine
A=M
0;JMP // Jump back to calling function

// Write third Block starting from R0 -> 16x16 black rectangle but starting 32 pixels to the right. Then go back to starting position
// Jump back to the line given in R1
(WRITE.2)
@R0
D=M
@tmp
M=D // Save starting position
@R0
M=M+1
M=M+1
@R1
D=M
@tmpLine
M=D // Save Line to Jump back to
@WRITE.2.END
D=A
@R1
M=D // Line for "WRITEBLOCk" to jump back to
@WRITE.1
0;JMP // Write the Block
(WRITE.2.END)
@tmp
D=M
@R0
M=D // Write initial screen starting position back to R0
@tmpLine
A=M
0;JMP // Jump back to calling function

// Write Pixel 4 || Return pointer back to R0 || Jump back to line given in R1
(WRITE.3)
@R0
D=M
@backtopixelAlt
M=D // Save Screen Pointer
@R1
D=M
@backtolineAlt
M=D
// now: write Pixel
@R0
M=M+1 // move 1 to the right
// Now: call 3rd pixel blocker
@BLOCK.3.END
D=A
@R1
M=D
@WRITE.2
0;JMP
(BLOCK.3.END)
@backtopixelAlt
D=M
@R0
M=D // return screen pointer to starting position
@backtolineAlt
A=M
0;JMP // Jump to calling position

// Write Pixel 5 || Return pointer back to R0 || Jump back to line given in R1
(BLOCK.4)
@R0
D=M
@backtopixelAlt
M=D // Save Screen Pointer
@R1
D=M
@backtolineAlt
M=D
// now: write Pixel
@R0
M=M+1
M=M+1 // move 2 to the right
// Now: call 3rd pixel blocker
@BLOCK.4.END
D=A
@R1
M=D
@BLOCK.2
0;JMP
(BLOCK.4.END)
@backtopixelAlt
D=M
@R0
M=D // return screen pointer to starting position
@backtolineAlt
A=M
0;JMP // Jump to calling position



// Write block x in line y || x = value in R2 || y = value in R3
// Jump back to line given in R1
// Set screen pointer back to R0 when finished
// Values in R3 is changed during the function
(PAINT)
@R0
D=M
@currentLocationScreen
M=D // Save the initial screen pointer location 
@R1
D=M
@currentLocationProgramm
M=D // Save the programm location to jump back to after execution

@PAINT.END
D=A
@R1
M=D // The called "Block-xxx" function shall jump back to the end of paint

(JUMPTOLINE) // Move to the line where the block shall be written
@R3
D=M
@CALLBLOCKFUNCTION
D;JEQ // If R2 is 0 -> write Block in this line
@R3
M=M-1 // else -> decrement R3 & move pointer to next line
@512
D=A
@R0
M=M+D // here -> move screen pointer to next line
@JUMPTOLINE
0;JMP // Loop again



// When this is reached, the screen pointer is at the start of line y = R3
(CALLBLOCKFUNCTION)
@R2
D=M
@WRITE.0
D;JEQ // if x = 0 -> Write Block 0 in current line
D=D-1
@WRITE.1
D;JEQ // if x = 1 -> Write Block 1 in current line
D=D-1
@WRITE.2
D;JEQ // if x = 2 -> Write Block 2 in current line
D=D-1
@WRITE.3
D;JEQ // if x = 3 -> Write Block 3 in current line
D=D-1
@WRITE.4
D;JEQ // if x = 4 -> Write Block 4 in current line


// If any error occurs -> PC runs into PAINT.END and calling function continues normally. Just without writing a block to screen
(PAINT.END)
@currentLocationScreen
D=M
@R0
M=D // reset screen pointer
@WRITEKEY.PAINT.INCREMENT.COUNTERS
0;JMP // Jump back to the function which called "PAINT"


/////////
(MODULO) // R4 % R5 = R6 || Jump to Value of R1
@R4 // get current R4 value
D=M
@R5 // subtract R5
D=D-M
@MODULO.RESULT 
D;JLT // If result is positive -> repeat
@R4
M=D 
@MODULO
0;JMP
(MODULO.RESULT) // Else -> save the result
@R4
D=M
@R6
M=D
@R1
A=M // Get the position to jump back to
0;JMP
////////




(END)
@END
0;JMP


