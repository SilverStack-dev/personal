Due to the number of requests I have had regarding my Ph.D. thesis,
I have made it available for download from

   http://www.knaggs.me.uk/thesis

This is a directory that contains a number of files:

	readme        10KB   - The file.  Contains the Abstract and
			       the Table of Contents for the full thesis.

	chap-1.pdf   151KB   - Overview
	chap-2.pdf   209KB   - Using IBM's NetBios
	chap-3.pdf    87KB   - Mixed Languages interface
	chap-4.pdf   134KB   - Formal Forth
	chap-5.pdf   174KB   - Stack Optimisation
	chap-6.pdf   147KB   - The Cell Type
	chap-7.pdf   166KB   - A Forth Type Checker
	chap-8.pdf   270KB   - The Event Calculus
	chap-9.pdf   117KB   - Conclusions and Recommendations

	annx-a.pdf   172KB   - Communicating Novix NC4016s
	annx-b.pdf   167KB   - Forth++ and the MACH1
	annx-c.pdf   160KB   - Mixed Languages Interface: Source Code

	thesis.pdf   897KB   - The full thesis in one file.

The files have been processed to print on both American and European (A4)
paper.  The chap/annx files contain a single chapter or appendix each, these
files also contain there own "references" section. The file "thesis.pdf"
is a copy of the full document, without the "references" sections, but
including the Bibliography.  As a resault of this reformatting, the page
numbers will NOT be consistent between the two versions.

	   ==================================================

		    Practical and Theoretical Aspects of
			 Forth Software Development


                       Peter Knaggs

	   ==================================================

				        Abstract
123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 
This is an investigation into the use of the Forth programming environment.
The main areas of enquiry were: interfacing Forth to other languages;
interfacing Forth and local area networks; and the use of RISC processors
with stack based architecture such as the NC4000 and Harris RTX series.

We describe how to interface Forth and C. We also provide a system with a
multi-tasking interrupt driven interface to the IBM NetBios networking
software and a simple, generic, method of task activation through message
passing.

Many aspects of the investigation proved to be dependent on a more thorough
theoretical underpinning for the Forth language.  The use of a type less
parameter stack means that a programmer must concern himself with the
intellectual burden of managing the parameter stack.  The mismatching of
stack elements can be the cause of subtle logic errors.  We therefore
investigated the possibility of developing a "type algebra" that would allow
us to develop a typed version of Forth.  This thesis includes a theory for a
"type signature algebra" for the stack based argument passing method used by
Forth.

To support the use of multi-tasking we provide a simple, but formal, theory
of concurrent tasks based on state machines that synchronise on events.  This
has a graphical notation for people who are not familiar with formal
notations.

We also looked at how formalisms might be used to define a semantic model for
the Forth language and how formalisms can help to define the relationship
between Forth's stack based virtual machine and register based target
processors.

	     ==================================================

   Table of Contents

   1  Overview
      1.1   Introduction
      1.2   Equipment
      1.3   Forth
      1.4   The Novix NC4000 Forth Engine
      1.5   The Harris RTX-2000 Forth Engine
      1.6   Networks
      1.7   Mixed Languages Interface
      1.8   Formal Methods
            1.8.1  Formal Forth
            1.8.2  Type Algebra
            1.8.3  The Event Calculus
   
   2  Using IBM's NetBios
      2.1   Introduction
      2.2   Functions
            2.2.1  Naming
            2.2.2  Sessions
            2.2.3  Datagrams
            2.2.4  Broadcasting
            2.2.5  House keeping
      2.3   Invoking NetBios Functions
      2.4   Multi-Tasking
      2.5   Examples
            2.5.1  Block Transfer
            2.5.2  Net-Chat
      2.6   Problems
            2.6.1  PolyForth
            2.6.2  Interrupts
            2.6.3  Porting
      2.7   Comparison with C interface
      2.8   Interface Code
            2.8.1  Error Handler
            2.8.2  Network Control Block
            2.8.3  Assembler Interface
            2.8.4  Low-Level interface
            2.8.5  General Support
            2.8.6  Naming Support
            2.8.7  Session Support
            2.8.8  Datagram Support
            2.8.9  Broadcast Support
      2.9   The "Net-Chat" Application
            2.9.1  Memory Buffers
            2.9.2  Listening
            2.9.3  Sending
            2.9.4  Initialisation
            2.9.5  Close Down
   
   3  Mixed Languages interface
      3.1   Principles
      3.2   Argument Passing
      3.3   Programming
      3.4   The C Heap
      3.5   Organisation
      3.6   Generalisation
   
   4  Formal Forth
      4.1   Introduction
      4.2   The Forth Toolbox
      4.3   The Basic Model
      4.4   Word Definitions
      4.5   Immediate Words
      4.6   Storage Units
      4.7   Stacks
      4.8   Code Definitions
      4.9   Wordlists
      4.10  Defining words
            4.10.1 High-Level words
            4.10.2 Immediate words
            4.10.3 Code words
      4.11  Dictionary Searching
   
   5  Stack Optimisation
      5.1   Introduction
      5.2   Code Generation
      5.3   Inline Compilation
      5.4   Peep-Hole Optimisation
            5.4.1  Conditionals
      5.5   Registers
      5.6   Optimisation using a Stack image
            5.6.1  Argument Passing
            5.6.2  Conditional execution
            5.6.3  Looping structures
   
   6  The Cell Type
      6.1   Introduction
      6.2   Stack Types
      6.3   Notation
      6.4   Rules
            6.4.1  Composition Rules
            6.4.2  Reduction Rules
            6.4.3  Wildcard Rules
      6.5   Simple Examples
      6.6   Multiple Signatures
      6.7   Pass by reference
      6.8   Control Structures
      6.9   Casting
      6.10  Strong vs Weak Typing
            6.10.1 Strong Typing
            6.10.2 Weak Typing
   
   7  A Forth Type Checker
      7.1   Invocation
      7.2   Stack Notation
      7.3   Commands
            7.3.1  Classes
            7.3.2  Type Command
            7.3.3  Stack Command
            7.3.4  Assume Command
            7.3.5  Assert Command
            7.3.6  Syntax Command
      7.4   Variable Stack Items
            7.4.1  Or - |
            7.4.2  Alternative descriptions - +
      7.5   Flow Control
      7.6   Defining words
            7.6.1  Pre-defined
            7.6.2  User-defined
      7.7   Vocabularies
      7.8   Error Log
            7.8.1  Error report
            7.8.2  Verbose reports
            7.8.3  Statistics
            7.8.4  Statistics flag
      7.9   Problems
   
   8  The Event Calculus
      8.1   Introduction
      8.2   State Machines
      8.3   The Formal Model
      8.4   An Algebra of machine behaviours
      8.5   Labelled Transitions
      8.6   Simple Examples
            8.6.1  The specification of mutual exclusion (without fairness)
            8.6.2  Asynchronous Events
            8.6.3  Value passing
            8.6.4  Mutual Exclusion with fairness
      8.7   A GCD algorithm, modelling parameter passing and procedure call
      8.8   Variables and Scopes
      8.9   Time
      8.10  The Dynamic model
      8.11  Combining the Event Calculus with Z schema calculus
      8.12  A Distributed seat booking system
   
   9  Conclusions and Recommendations
      9.1   Introduction
      9.2   Networks
      9.3   Mixed Languages Interface
      9.4   Formal Forth
      9.5   Stack Optimisation
      9.6   Type Algebra
      9.7   Forth Type Checker
      9.8   The Event Calculus
      9.9   Future Directions
            9.9.1  Type Algebra
            9.9.2  Formal Forth
            9.9.3  Event Calculus
   
   A  Communicating Novix NC4016s
      A.1   Introduction
      A.2   Programming
            A.2.1  cmForth
            A.2.2  SCForth
            A.2.3  PolyForth
            A.2.4  FATWIN
      A.3   Single Boards
      A.4   Host Services
      A.5   Parallel Boards
            A.5.1  First Method
            A.5.2  Second Method
            A.5.3  Comparison
      A.6   Communicating Systems
            A.6.1  Hardware Restrictions
            A.6.2  Communication
      A.7   Code
            A.7.1  Multiple Boards "Boot" code
            A.7.2  First attempt at providing Host Services
            A.7.3  Revised Boot and Host code
   
   B  Forth++ and the MACH1
      B.1   The MACH1
      B.2   The MACH2
      B.3   Forth++
            B.3.1  Memory Organisation
            B.3.2  Multi-Tasking and Windows
            B.3.3  Argument Records
      B.4   The Multi-Processor Forth Interpreter
            B.4.1  The Users View
            B.4.2  Implementation Notes
      B.5   Code Optimisation
      B.6   Graphics
   
   C  Mixed Languages Interface: Source Code
      C.1   Loader
      C.2   Making the loader
      C.3   Overlay initialisation
      C.4   Context Switching
      C.5   Stack access
      C.6   User code
      C.7   Making the C Overlay

	     ==================================================

-----------------------------------------------------------------------------
        C makes you think that C is the world's greatest language.
    Forth makes you think that you're the world's greatest programmer.
-----------------------------------------------------------------------------
