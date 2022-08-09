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

// Check .
@46
D=A
@SAVEKEY
D=D-M
@RESET
D;JEQ

// Check A
@65
D=A
@SAVEKEY
D=D-M
@A
D;JEQ

// Check C
@67
D=A
@SAVEKEY
D=D-M
@C
D;JEQ


// Check E
@69
D=A
@SAVEKEY
D=D-M
@E
D;JEQ

// Check I
@73
D=A
@SAVEKEY
D=D-M
@I
D;JEQ

// Check J
@74
D=A
@SAVEKEY
D=D-M
@J
D;JEQ

// Check M
@77
D=A
@SAVEKEY
D=D-M
@M
D;JEQ

// Check N
@78
D=A
@SAVEKEY
D=D-M
@N
D;JEQ

// Check O
@79
D=A
@SAVEKEY
D=D-M
@O
D;JEQ

// Check S
@83
D=A
@SAVEKEY
D=D-M
@S
D;JEQ

// Check Space
@32
D=A
@SAVEKEY
D=D-M
@EMPTY
D;JEQ

// Check Q -> WRITE HEART
@81
D=A
@SAVEKEY
D=D-M
@HEART
D;JEQ

// If nothing was recognized -> get back to checking input and clear @KBD / @SAVEKEY
@KBD
M=0
@SAVEKEY
M=0
@WAITLOOP
0;JMP


(EMPTY)
@R0
M=M+1
M=M+1
M=M+1
M=M+1
@4
D=A
@lettersInRow
M=M+D
D=M
@27
D=D-A
@SKIPTONEXTROW
D;JGT
@WAITLOOP
0;JMP

(SKIPTONEXTCHAR)
@4
D=A
@lettersInRow
M=M+D
D=M
@27
D=D-A
@SKIPTONEXTROW
D;JGT
@2044
D=A
@R0
M=M-D
@WAITLOOP
0;JMP

(SKIPTONEXTCHARSPECIALM)
@6
D=A
@lettersInRow
M=M+D
D=M
@27
D=D-A
@SKIPTONEXTROW
D;JGT
@2042 // Might be 2046
D=A
@R0
M=M-D
@WAITLOOP
0;JMP

(SKIPTONEXTCHARSPECIALHEART)
@7
D=A
@lettersInRow
M=M+D
D=M
@27
D=D-A
@SKIPTONEXTROW
D;JGT
@2041 
D=A
@R0
M=M-D
@WAITLOOP
0;JMP

(SKIPTONEXTCHARSPECIALN)
@5
D=A
@lettersInRow
M=M+D
D=M
@27
D=D-A
@SKIPTONEXTROW
D;JGT
@2043 // Might be 2045
D=A
@R0
M=M-D
@WAITLOOP
0;JMP



(SKIPTONEXTROW)
@currentRow
M=M+1
D=M
D=D-1
D=D-1
@CACHE
D;JEQ // If second Line is full -> reset and go back to start
@rowStartingPoint
D=M
@3072 // Move to next row
D=D+A
@R0
M=D // Write new Value to pointer
@rowStartingPoint
M=D
@lettersInRow
M=0


@WAITLOOP
0;JMP

(CACHE) // Called only from SKIPNEXTROW to keep the letters on the screen until you press any key
@KBD
D=M
@CACHE
D;JEQ
@SAVEKEY
M=D
(WAITFORRELEASEINCACHE)
@SAVEKEY
D=M
@KBD
D=D-M
@WAITFORRELEASEINCACHE
D;JNE
@RESET
0;JMP




///// Write an A
(A)
// Saving starting position on screen
@R0
D=M
@start
M=D
@KBD
M=0
// First Line of A written here -> Pixel 2
@ASECOND
D=A
@R1
M=D
@WRITESECONDBLOCK
0;JMP 

// Second Line of A written here -> Pixel 1 & 3
(ASECOND)
@512
D=A
@R0
M=M+D // Jump to next line
// now: Write the pixels
@ATHIRD
D=A
@R1
M=D
@BLOCKFIRSTLAST
0;JMP

// Third Line of A written here -> Pixel 1&3
(ATHIRD)
@512
D=A
@R0
M=M+D // Jump to next line
// now: Write the pixels
@AFOURTH
D=A
@R1
M=D
@BLOCKFIRSTLAST
0;JMP

// Fourth Line of A written here -> Pixel 1-3
(AFOURTH)
@512
D=A
@R0
M=M+D // Jump to next line
@ALASTLINE
D=A
@R1
M=D
@BLOCKALL
0;JMP



(ALASTLINE)
@512
D=A
@R0
M=M+D // Jump to next line
// now: write first pixel of 3rd Line
@ALASTLINE2
D=A
@R1
M=D // Save Position to Jump back to
@WRITEBLOCK
0;JMP
(ALASTLINE2)
// now: write third Pixel in third line
@SKIPTONEXTCHAR
D=A
@R1
M=D
@WRITETHIRDBLOCK
0;JMP

///// End of Writing an A

/////
// WRITE an C
/////
// Setup 
(C)
@R0
D=M
@start
M=D
@KBD
M=0

// First Line C
@CSECONDLINE
D=A
@R1
M=D
@BLOCKALL
0;JMP

// Second Line C
(CSECONDLINE)
@512
D=A
@R0
M=M+D
@CTHIRDLINE
D=A
@R1
M=D
@WRITEBLOCK
0;JMP

// Third Line C
(CTHIRDLINE)
@512
D=A
@R0
M=M+D
@CFOURTHLINE
D=A
@R1
M=D
@WRITEBLOCK
0;JMP


// Fourth Line C
(CFOURTHLINE)
@512
D=A
@R0
M=M+D
@CFIFTHLINE
D=A
@R1
M=D
@WRITEBLOCK
0;JMP

// Fifth Line C
(CFIFTHLINE)
@512
D=A
@R0
M=M+D
@SKIPTONEXTCHAR
D=A
@R1
M=D
@BLOCKALL
0;JMP
////// END of writing C



/////
// WRITE an E
/////
// Setup 
(E)
@R0
D=M
@start
M=D
@KBD
M=0

// First Line E
@ESECONDLINE
D=A
@R1
M=D
@BLOCKALL
0;JMP

// Second Line E
(ESECONDLINE)
@512
D=A
@R0
M=M+D
@ETHIRDLINE
D=A
@R1
M=D
@WRITEBLOCK
0;JMP

// Third Line E
(ETHIRDLINE)
@512
D=A
@R0
M=M+D
@EFOURTHLINE
D=A
@R1
M=D
@BLOCKFIRSTSECOND
0;JMP


// Fourth Line E
(EFOURTHLINE)
@512
D=A
@R0
M=M+D
@EFIFTHLINE
D=A
@R1
M=D
@WRITEBLOCK
0;JMP

// Fifth Line E
(EFIFTHLINE)
@512
D=A
@R0
M=M+D
@SKIPTONEXTCHAR
D=A
@R1
M=D
@BLOCKALL
0;JMP
////// END of writing E

/////
// WRITE an I
/////

(I)
@R0
D=M
@start
M=D
@KBD
M=0

// First Line I
@ISECONDLINE
D=A
@R1
M=D
@BLOCKALL
0;JMP

// Second Line I
(ISECONDLINE)
@512
D=A
@R0
M=M+D
@ITHIRDLINE
D=A
@R1
M=D
@WRITESECONDBLOCK
0;JMP

// Third Line I
(ITHIRDLINE)
@512
D=A
@R0
M=M+D
@IFOURTHLINE
D=A
@R1
M=D
@WRITESECONDBLOCK
0;JMP


// Fourth Line I
(IFOURTHLINE)
@512
D=A
@R0
M=M+D
@IFIFTHLINE
D=A
@R1
M=D
@WRITESECONDBLOCK
0;JMP

// Fifth Line I
(IFIFTHLINE)
@512
D=A
@R0
M=M+D
@SKIPTONEXTCHAR
D=A
@R1
M=D
@BLOCKALL
0;JMP
////// END of writing I


/////
// WRITE an J
/////
// Setup 
(J)
@R0
D=M
@start
M=D
@KBD
M=0

// First Line J
@JSECONDLINE
D=A
@R1
M=D
@BLOCKSECONDTHIRD
0;JMP

// Second Line J
(JSECONDLINE)
@512
D=A
@R0
M=M+D
@JTHIRDLINE
D=A
@R1
M=D
@WRITETHIRDBLOCK
0;JMP

// Third Line J
(JTHIRDLINE)
@512
D=A
@R0
M=M+D
@JFOURTHLINE
D=A
@R1
M=D
@WRITETHIRDBLOCK
0;JMP


// Fourth Line J
(JFOURTHLINE)
@512
D=A
@R0
M=M+D
@JFIFTHLINE
D=A
@R1
M=D
@BLOCKFIRSTLAST
0;JMP

// Fifth Line J
(JFIFTHLINE)
@512
D=A
@R0
M=M+D
@SKIPTONEXTCHAR
D=A
@R1
M=D
@BLOCKSECONDTHIRD
0;JMP
////// END of writing J








/////
// WRITE an M
/////

(M)
@R0
D=M
@start
M=D
@KBD
M=0

// First Line M
@MFIRSTLINE2
D=A
@R1
M=D
@WRITEBLOCK
0;JMP
(MFIRSTLINE2)
@MSECONDLINE
D=A
@R1
M=D
@BLOCKFIFTH
0;JMP


// Second Line M
(MSECONDLINE)
@512
D=A
@R0
M=M+D
@MSECONDLINE2
D=A
@R1
M=D
@BLOCKFIRSTSECOND
0;JMP
(MSECONDLINE2)
@MSECONDLINE3
D=A
@R1
M=D
@BLOCKFOURTH
0;JMP
(MSECONDLINE3)
@MTHIRDLINE
D=A
@R1
M=D
@BLOCKFIFTH
0;JMP


// Third Line M
(MTHIRDLINE)
@512 // 512 -2 of the shift operation from line before
D=A
@R0
M=M+D
@MTHIRDLINE2
D=A
@R1
M=D
@BLOCKFIRSTLAST
0;JMP
(MTHIRDLINE2)
@MFOURTHLINE
D=A
@R1
M=D
@BLOCKFIFTH
0;JMP


// Fourth Line M
(MFOURTHLINE)
@512 // 512 -2 of the shift operation from line before
D=A
@R0
M=M+D
@FOURTHLINE2
D=A
@R1
M=D
@BLOCKFIRSTLAST
0;JMP
(FOURTHLINE2)
@MFIFTHLINE
D=A
@R1
M=D
@BLOCKFIFTH
0;JMP

// Fifth Line M
(MFIFTHLINE)
@512
D=A
@R0
M=M+D
@FIFTHLINE2
D=A
@R1
M=D
@BLOCKFIRSTLAST
0;JMP
(FIFTHLINE2)
@SKIPTONEXTCHARSPECIALM
D=A
@R1
M=D
@BLOCKFIFTH
0;JMP
////// END of writing M



/////
// WRITE an N
/////

(N)
@R0
D=M
@start
M=D
@KBD
M=0

// First Line N
@NSECONDLINE
D=A
@R1
M=D
@BLOCKFIRSTFOURTH
0;JMP

// Second Line N
(NSECONDLINE)
@512
D=A
@R0
M=M+D
@NTHIRDLINE
D=A
@R1
M=D
@BLOCKFIRSTFOURTH
0;JMP

// Third Line N
(NTHIRDLINE)
@512
D=A
@R0
M=M+D
@NTHIRDLINE2
D=A
@R1
M=D
@BLOCKFIRSTSECOND
0;JMP
(NTHIRDLINE2)
@NFOURTHLINE
D=A
@R1
M=D
@BLOCKFOURTH
0;JMP


// Fourth Line N
(NFOURTHLINE)
@512
D=A
@R0
M=M+D
@NFOURTHLINE2
D=A
@R1
M=D
@BLOCKFIRSTFIFTH
0;JMP
(NFOURTHLINE2)
@NFIFTHLINE
D=A
@R1
M=D
@WRITETHIRDBLOCK
0;JMP

// Fifth Line N
(NFIFTHLINE)
@512
D=A
@R0
M=M+D
@SKIPTONEXTCHARSPECIALN
D=A
@R1
M=D
@BLOCKFIRSTFOURTH
0;JMP
////// END of writing N



/////
// WRITE an O
/////

(O)
@R0
D=M
@start
M=D
@KBD
M=0

// First Line O
@OSECONDLINE
D=A
@R1
M=D
@BLOCKSECONDTHIRD
0;JMP

// Second Line O
(OSECONDLINE)
@512
D=A
@R0
M=M+D
@OTHIRDLINE
D=A
@R1
M=D
@BLOCKFIRSTFOURTH
0;JMP

// Third Line O
(OTHIRDLINE)
@512
D=A
@R0
M=M+D
@OFOURTHLINE
D=A
@R1
M=D
@BLOCKFIRSTFOURTH
0;JMP


// Fourth Line O
(OFOURTHLINE)
@512
D=A
@R0
M=M+D
@OFIFTHLINE
D=A
@R1
M=D
@BLOCKFIRSTFOURTH
0;JMP

// Fifth Line O
(OFIFTHLINE)
@512
D=A
@R0
M=M+D
@SKIPTONEXTCHARSPECIALN
D=A
@R1
M=D
@BLOCKSECONDTHIRD
0;JMP
////// END of writing O

/////
// WRITE an S
/////
// Setup 
(S)
@R0
D=M
@start
M=D
@KBD
M=0

// First Line S
@SSECONDLINE
D=A
@R1
M=D
@BLOCKALL
0;JMP

// Second Line S
(SSECONDLINE)
@512
D=A
@R0
M=M+D
@STHIRDLINE
D=A
@R1
M=D
@WRITEBLOCK
0;JMP

// Third Line S
(STHIRDLINE)
@512
D=A
@R0
M=M+D
@SFOURTHLINE
D=A
@R1
M=D
@BLOCKALL
0;JMP


// Fourth Line S
(SFOURTHLINE)
@512
D=A
@R0
M=M+D
@SFIFTHLINE
D=A
@R1
M=D
@WRITETHIRDBLOCK
0;JMP

// Fifth Line S
(SFIFTHLINE)
@512
D=A
@R0
M=M+D
@SKIPTONEXTCHAR
D=A
@R1
M=D
@BLOCKALL
0;JMP
////// END of writing S



/////
// WRITE a HEART
/////

(HEART)
@R0
D=M
@start
M=D
@KBD
M=0

// First Line HEART
@HEARTSECONDLINE
D=A
@R1
M=D
@BLOCKSECONDFOURTH
0;JMP


// Second Line HEART
(HEARTSECONDLINE)
@512
D=A
@R0
M=M+D
@HEARTSECONDLINE2
D=A
@R1
M=D
@BLOCKFIRSTLAST
0;JMP
(HEARTSECONDLINE2)
@HEARTTHIRDLINE
D=A
@R1
M=D
@BLOCKFIFTH
0;JMP


// Third Line HEART
(HEARTTHIRDLINE)
@512 // Next Line
D=A
@R0
M=M+D
@HEARTTHIRDLINE2
D=A
@R1
M=D
@WRITEBLOCK
0;JMP
(HEARTTHIRDLINE2)
@HEARTFOURTHLINE
D=A
@R1
M=D
@BLOCKFIFTH
0;JMP


// Fourth Line HEART
(HEARTFOURTHLINE)
@512 // Next Line
D=A
@R0
M=M+D
@HEARTFIFTHLINE
D=A
@R1
M=D
@BLOCKSECONDFOURTH
0;JMP

// Fifth Line HEART
(HEARTFIFTHLINE)
@512
D=A
@R0
M=M+D
@SKIPTONEXTCHARSPECIALHEART
D=A
@R1
M=D
@WRITETHIRDBLOCK
0;JMP
////// END of writing HEART






// Write Pixel 1-3 || Return pointer back to R0 || Jump back to line given in R1 
(BLOCKALL)
@R0
D=M
@backtopixel
M=D // Save Screen Pointer
@R1
D=M
@backtoline
M=D
// now: write first pixel
@BLOCKALL2
D=A
@R1
M=D // Save Position to Jump back to
@WRITEBLOCK
0;JMP
(BLOCKALL2)
// now: write second Pixel in fourth line
@BLOCKALL3
D=A
@R1
M=D
@WRITESECONDBLOCK
0;JMP
(BLOCKALL3)
// Now: write third Pixel in fourth Line
@BLOCKALLEND
D=A
@R1
M=D
@WRITETHIRDBLOCK
0;JMP
(BLOCKALLEND)
@backtopixel
D=M
@R0
M=D // return screen pointer to starting position
@backtoline
A=M
0;JMP // Jump to calling position

// Write Pixel 1 & 4 || Return pointer back to R0 || Jump back to line given in R1
(BLOCKFIRSTFOURTH)
@R0
D=M
@backtopixel
M=D // Save Screen Pointer
@R1
D=M
@backtoline
M=D
// now: write first pixel of 2nd Line
@BLOCKFIRSTFOURTH2
D=A
@R1
M=D // Save Position to Jump back to
@WRITEBLOCK
0;JMP
(BLOCKFIRSTFOURTH2)
// now: write fourth Pixel in second line
@BLOCKFIRSTFOURTHEND
D=A
@R1
M=D
@BLOCKFOURTH
0;JMP
(BLOCKFIRSTFOURTHEND)
@backtopixel
D=M
@R0
M=D // return screen pointer to starting position
@backtoline
A=M
0;JMP // Jump to calling position

// Write Pixel 2 & 4 || Return pointer back to R0 || Jump back to line given in R1
(BLOCKSECONDFOURTH)
@R0
D=M
@backtopixel
M=D // Save Screen Pointer
@R1
D=M
@backtoline
M=D
// now: write first pixel of 2nd Line
@BLOCKSECONDFOURTH2
D=A
@R1
M=D // Save Position to Jump back to
@WRITESECONDBLOCK
0;JMP
(BLOCKSECONDFOURTH2)
// now: write fourth Pixel in second line
@BLOCKSECONDFOURTHEND
D=A
@R1
M=D
@BLOCKFOURTH
0;JMP
(BLOCKSECONDFOURTHEND)
@backtopixel
D=M
@R0
M=D // return screen pointer to starting position
@backtoline
A=M
0;JMP // Jump to calling position

// Write Pixel 1 & 5 || Return pointer back to R0 || Jump back to line given in R1
(BLOCKFIRSTFIFTH)
@R0
D=M
@backtopixel
M=D // Save Screen Pointer
@R1
D=M
@backtoline
M=D
// now: write first pixel of 2nd Line
@BLOCKFIRSTFIFTH2
D=A
@R1
M=D // Save Position to Jump back to
@WRITEBLOCK
0;JMP
(BLOCKFIRSTFIFTH2)
// now: write third Pixel in second line
@BLOCKFIRSTFIFTHEND
D=A
@R1
M=D
@BLOCKFOURTH
0;JMP
(BLOCKFIRSTFIFTHEND)
@backtopixel
D=M
@R0
M=D // return screen pointer to starting position
@backtoline
A=M
0;JMP // Jump to calling position


// Write Pixel 1 and 3 || Return pointer back to R0 || Jump back to line given in R1
(BLOCKFIRSTLAST)
@R0
D=M
@backtopixel
M=D // Save Screen Pointer
@R1
D=M
@backtoline
M=D
// now: write first pixel of 2nd Line
@BLOCKFIRSTLAST2
D=A
@R1
M=D // Save Position to Jump back to
@WRITEBLOCK
0;JMP
(BLOCKFIRSTLAST2)
// now: write third Pixel in second line
@BLOCKFIRSTLASTEND
D=A
@R1
M=D
@WRITETHIRDBLOCK
0;JMP
(BLOCKFIRSTLASTEND)
@backtopixel
D=M
@R0
M=D // return screen pointer to starting position
@backtoline
A=M
0;JMP // Jump to calling position

// Write Pixel 4 || Return pointer back to R0 || Jump back to line given in R1
(BLOCKFOURTH)
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
@BLOCKFOURTHEND
D=A
@R1
M=D
@WRITETHIRDBLOCK
0;JMP
(BLOCKFOURTHEND)
@backtopixelAlt
D=M
@R0
M=D // return screen pointer to starting position
@backtolineAlt
A=M
0;JMP // Jump to calling position

// Write Pixel 5 || Return pointer back to R0 || Jump back to line given in R1
(BLOCKFIFTH)
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
@BLOCKFIFTHEND
D=A
@R1
M=D
@WRITETHIRDBLOCK
0;JMP
(BLOCKFIFTHEND)
@backtopixelAlt
D=M
@R0
M=D // return screen pointer to starting position
@backtolineAlt
A=M
0;JMP // Jump to calling position


// Write Pixel 1 and 2 || Return pointer back to R0 || Jump back to line given in R1
(BLOCKFIRSTSECOND)
@R0
D=M
@backtopixel
M=D // Save Screen Pointer
@R1
D=M
@backtoline
M=D
// now: write first pixel
@BLOCKFIRSTSECOND2
D=A
@R1
M=D // Save Position to Jump back to
@WRITEBLOCK
0;JMP
(BLOCKFIRSTSECOND2)
// now: write second Pixel
@BLOCKFIRSTSECONDEND
D=A
@R1
M=D
@WRITESECONDBLOCK
0;JMP
(BLOCKFIRSTSECONDEND)
@backtopixel
D=M
@R0
M=D // return screen pointer to starting position
@backtoline
A=M
0;JMP // Jump to calling position





// Write Pixel 2 and 3 || Return pointer back to R0 || Jump back to line given in R1
(BLOCKSECONDTHIRD)
@R0
D=M
@backtopixel
M=D // Save Screen Pointer
@R1
D=M
@backtoline
M=D
// now: write second pixel
@BLOCKSECONDTHIRD2
D=A
@R1
M=D // Save Position to Jump back to
@WRITESECONDBLOCK
0;JMP
(BLOCKSECONDTHIRD2)
// now: write third Pixel
@BLOCKSECONDTHIRDEND
D=A
@R1
M=D
@WRITETHIRDBLOCK
0;JMP
(BLOCKSECONDTHIRDEND)
@backtopixel
D=M
@R0
M=D // return screen pointer to starting position
@backtoline
A=M
0;JMP // Jump to calling position








// Write second Block starting from R0 -> 16x16 black rectangle but starting 16 pixels to the right. Then go back to starting position
// Jump back to the line given in R1
(WRITESECONDBLOCK)
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
@WRITESECONDBLOCKEND
D=A
@R1
M=D // Line for "WRITEBLOCk" to jump back to
@WRITEBLOCK
0;JMP // Write the Block
(WRITESECONDBLOCKEND)
@tmp
D=M
@R0
M=D // Write initial screen starting position back to R0
@tmpLine
A=M
0;JMP // Jump back to calling function

// Write third Block starting from R0 -> 16x16 black rectangle but starting 32 pixels to the right. Then go back to starting position
// Jump back to the line given in R1
(WRITETHIRDBLOCK)
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
@WRITETHIRDBLOCKEND
D=A
@R1
M=D // Line for "WRITEBLOCk" to jump back to
@WRITEBLOCK
0;JMP // Write the Block
(WRITETHIRDBLOCKEND)
@tmp
D=M
@R0
M=D // Write initial screen starting position back to R0
@tmpLine
A=M
0;JMP // Jump back to calling function

(SPACE)



(END)
@END
0;JMP


// From Current position (R0): Draw a 16x16 Black Rectangle -> 16 to the right and 16 downwards
// Then go Back to the starting position
// Jump back to the line given in R1
(WRITEBLOCK)
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