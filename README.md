# Glaux
Update of "very old and buggy" library GLAUX on Windows 11 64 bit (create very new version 64 bit, and create DLL too). Very good challenge, with IDE Code::Blocks.

It's just to see if this library can be recompiled with all free compilers C/C++ available on Windows 11 64 bit in ... 2025 (already !!).

Test realized with help of IDE Code::Blocks (because this IDE can adapt very easy with all categories of "strange" compilers C/C++, and also very "celebre" compilers available (at date) on W11, and because I success build "an test" of build DLL (very simply DLL that do arithmetic calculs on integer and double : https://github.com/tdechaize/Test_DLL_ALL) with ALL of these compilers. Today, I want confront this first experience with real library "in real world"...

# Result of test presence of library GLAUX into free compilers on Windows 11 64 bit
				
Behind, you can list version of all compilers installed on my computer with last Windows 11 24H4 version, and the
objective of this note is to verify presence or not of GLAUX library with "native" installation of theses free 
compilers on Windows 11 64 bits. 

Just to verify this, in first time, result of these three commands (WMIC will must be deprecated in future version of Windows !!) :

"wmic OS get NAME"
Name
Microsoft Windows 11 Famille|C:\WINDOWS|\Device\Harddisk0\Partition3
"wmic OS get Version"
Version
10.0.26100
"echo "Processor architecture : %PROCESSOR_ARCHITECTURE%""
"Processor architecture : AMD64"								(In truth, Intel(R) Core(TM) i5-10300H CPU   -) !!! )

Initial version of Borland C/C++ (32 bit only, version 5.5.1 is last free before buyout by Embarcadero)
	- bcc32 version 5.5.1 for Win32 Copyright (c) 1993, 2000 Borland, InstalledDir: C:\BCC55\bin
	
	Absence of library GLAUX.LIB with this compiler !!!

Development Package of MinGW64 available into improved version of IDE CodeBlocks, nigthly build 2023 :
	- gcc (MinGW-W64 x86_64-ucrt-posix-seh, built by Brecht Sanders) 13.1.0 (64 bits), InstalledDir : C:\CodeBlocks\MinGW\bin
	
	Absence of this library with version 64 bit !!! 

Development Package of CLANG, leaned at MinGW (32 ou 64 bits) included in package MSYS2 (32 ou 64 bits)
	- clang version 19.1.4, Target: i686-w64-windows-gnu, Thread model: posix, InstalledDir : C:/msys64/mingw32/bin

	Presence of library libglaux.a into C:\msys64\mingw32\lib directory and include file "glaux.h" into 
		C:\msys64\mingw32\include\GL directory.	

	- clang version 19.1.4, Target: x86_64-w64-windows-gnu, Thread model: posix, InstalledDir : C:/msys64/mingw64/bin
	
	But absence of this library with version 64 bit !!! 

Development Package of CLANG, leaned at MinGW (32 ou 64 bits) includedd in package WinLibs
	- clang version 19.1.1 (built by Brecht Sanders, r4), Target: i686-w64-windows-gnu, Thread model: posix,
			InstalledDir : C:/mingw32/bin
			
	Presence of library libglaux.a into C:\mingw32\i686-w64-mingw32\lib directory and include file "glaux.h" into 
		C:\mingw32\i686-w64-mingw32\include\GL directory.	
		
	- clang version 19.1.1 (built by Brecht Sanders, r4), Target: x86_64-w64-windows-gnu, Thread model: posix,
			InstalledDir : C:/mingw64/bin
			
	But absence of this library with version 64 bit !!! 

Development Package of CLANG, leaned at MS Visual C/C++ (version Visual Studio Community 2022 + kits Windows) (32 ou 64 bits)
	- clang version 19.1.5, Target: i686-pc-windows-msvc, Thread model: posix, InstalledDir : C:\Program Files (x86)\LLVM\bin
	
	Absence of this library with version 32 bit !!! 

	- clang version 19.1.5, Target: x86_64-pc-windows-msvc, Thread model: posix, InstalledDir : C:\Program Files\LLVM\bin
	
	Absence of this library with version 64 bit !!! 

CYGWIN64 initial version but with addon MinGW (32 et 64 bit) and generation tool "basic" Make (and tool CMAKE too), three
compilers GCC :
	- gcc 12.4.0 ("native" version 64 bit), 	InstalledDir : C:/CYGWIN64/bin
	
	Absence of this library with "native" version 64 bit !!! 
	
	- i686-w64-mingw32-gcc (GCC) 12.4.0 (32 bit), InstalledDir : C:/CYGWIN64/bin

	Presence of library libglaux.a into C:\cygwin64\usr\i686-w64-mingw32\sys-root\mingw\lib directory and include file "glaux.h" into 
		C:\cygwin64\usr\i686-w64-mingw32\sys-root\mingw\include\GL directory.		
	
	- x86_64-w64-mingw32-gcc (GCC) 12.4.0 (64 bit), InstalledDir : C:/CYGWIN64/bin
	
	Absence of this library with version 64 bit !!! 
	
Digital Mars Compiler (version of installation package  : 8.57, 32 bit only)
	- dmc Digital Mars Compiler Version 8.42n. Copyright (C) Digital Mars 2000-2004, InstalledDir : C:\dm\bin
	
	Absence of this library with version 32 bit (not included in this distribution).

LCC compiler (version 32 and 64 bit)
	- lcc, Logiciels/Informatique lcc-win32 version 3.8., Compilation date: Mar 29 2013 13:11:27, InstalledDir : C:\lcc\bin

	Presence of library glaux.lib into C:\lcc\lib and include file "glaux.h" into C:\lcc\include\gl directory.	

	- lcc64, Logiciels/Informatique lcc-win (64 bits) version 4.1., Compilation date: Oct 27 2016 16:34:50,
		InstalledDir : C:\lcc64\bin
		
	Presence of library glaux.lib into C:\lcc64\lib64 and include file "glaux.h" into C:\lcc64\include64\gl directory.	

Development Package  "officiel" of MinGW (32 bit) (MinGW refuse to migrate to 64 bit !!!)
	- gcc (MinGW.org GCC Build-2) 9.2.0, 	InstalledDir: C:\MinGW\bin
	
	Presence of library libglaux.a into C:\MinGW\lib directory and include file "glaux.h" into 
		C:\MinGW\include\GL directory.	

Development Package of MinGW (32 et 64 bits) de la version MSYS2 :
	- gcc (Rev5, Built by MSYS2 project) 14.2.0, InstalledDir : C:/msys64/mingw32/bin
	
	Presence of library libglaux.a into C:\msys64\mingw32\lib directory and include file "glaux.h" into 
		C:\msys64\mingw32\include\GL directory.	
		
	- gcc (Rev5, Built by MSYS2 project) 14.2.0, InstalledDir : C:/msys64/mingw64/bin

	But absence of this library with version 64 bit !!! 

Development Package of MinGW (32 and 64 bit) included in package version Winlibs :
	- gcc (MinGW-W64 i686-ucrt-posix-dwarf, built by Brecht Sanders, r4) 14.2.0, InstalledDir : C:/mingw32/bin
	
	Presence of library libglaux.a into C:\mingw32\i686-w64-mingw32\lib directory and include file "glaux.h" into 
		C:\mingw32\i686-w64-mingw32\include\GL directory.
		
	- gcc (MinGW-W64 x86_64-ucrt-posix-seh, built by Brecht Sanders, r4) 14.2.0, InstalledDir : C:/mingw64/bin
			
	But absence of this library with version 64 bit !!! 
	
Development Package of OneAPI Intel compiler leaned at MSVC (32 and 64 bit) :
	- Ident of compiler : icx.exe + icpx.exe : Intel(R) oneAPI DPC++/C++ Compiler 2024.2.0 (2024.2.0.20240602), 
		Target: x86_64-pc-windows-msvc,
	- InstalledDir : 			C:\Program Files (X86)\Intel\oneAPI\compiler\latest\bin 
			(warning, and also, ..\bin32 if you select 32 bit version with "-m32" flag during compilation)

	Absence of this library with version 32 or 64 bit !!! 

Version of compiler Pelles C (32 et 64 bits, same version of generation tools, but with different configurations
of libraries path) :
	- Pelles ISO C Compiler, Version 12.00.1, Copyright (c) Pelle Orinius 1999-2023, InstalledDir : C:/PellesC/bin
	
	Presence of library glaux.lib into C:\PellesC\lib\Win and include file "glaux.h" into C:\PellesC\include\Win\gl directory.
	
	But absence of this library with version 64 bit !!! -> C:\PellesC\lib\Win64

Package de développement MinGW64 disponible avec une version de RedPanda (IDE) fork de Dev-Cpp plus maintenu (64 bits) :
	- gcc (x86_64-posix-seh-rev1, Built by MinGW-W64 project) 11.4.0, InstalledDir : C:/Program Files/RedPanda-Cpp/MinGW64/bin
	
	Absence of this library with this version og GCC 64 bit !!!

Package de développement TDM / MinGW (32 et 64 bits) :
	- gcc (tdm-1) 10.3.0, InstalledDir : C:/TDM-GCC-32/bin
	
	Presence of library libglaux.a into C:\TDM-GCC-32\lib directory and absence of include file "glaux.h" into 
		C:\TDM-GCC-32\include\GL directory !!!
		
	- gcc (tdm64-1) 10.3.0, InstalledDir : C:/TDM-GCC-64/bin
	
	But absence of this library with version 64 bit !!! -> C:\TDM-GCC-64\x86_64-w64-mingw32\lib (but prsence into 
		C:\TDM-GCC-64\x86_64-w64-mingw32\lib32) 

Package de développement Visual C/C++ issu de l'installation de Visual Studio 2022, version 17.12.3 et du Kit de developpement
Windows version 10.0.22621.0 (32 et 64 bits) :
	- cl, Compilateur d'optimisation Microsoft (R) C/C++ version 19.42.34435 pour x86, (32 bits)
		InstalledDir : C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.42.34433\bin\HostX86\x86
		
	Absence of this library with version 32 bit !!! 
	
	- cl, Compilateur d'optimisation Microsoft (R) C/C++ version 19.42.34435 pour x64, (64 bits)
		InstalledDir : C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.42.34433\bin\HostX64\x64

	Absence of this library with version 64 bit !!! 
	
Version améliorée du compilateur Open Watcom C/C++ 2.0 (celle disponible sur GitHub, pas celle de Sourceforge) (32 ou 64 bits)
	- wcl386, Open Watcom C/C++ x86 32-bit Compile and Link Utility, Version 2.0 beta Nov  8 2023 02:00:11 (32-bit),
		InstalledDir : C:\WATCOM\binnt

	Absence of this library with version 32 bit !!! 	

	- wcl386, Open Watcom C/C++ x86 32-bit Compile and Link Utility, Version 2.0 beta Nov  8 2023 02:45:53 (64-bit),
		InstalledDir : C:\WATCOM\binnt64

	Absence of this library with version 32 bit (because same with change of binaries directory, targets with these version
	"64 bit" of compiler Pelles C are ALWAYS in 32 bit !!!).  !!!
	
Bilan of these test : only presence of library GLAUX into 10 versions of free compilers on 30 in full (30%, and only to 32 bit,
						except with LCC compiler 64 bit)

		Borland C/C++ 5.5.1 (32 bit only) 					  Not OK
		MinGW64 available into IDE CodeBlocks				  Not OK
		CLANG included MSYS2 (32 bit)							        OK
		CLANG included MSYS2 (64 bit)						      Not OK
		CLANG included WinLibs (32 bit)							      OK
		CLANG included WinLibs (64 bit)						    Not OK
		CLANG leaned at MSVC (32 bit)						      Not OK
		CLANG leaned at MSVC (64 bit)						      Not OK
		GCC "native" of CYGWIN64 (64 bit)					    Not OK
		GCC of MinGW32 into CYGWIN64 (32 bit)					    OK
		GCC of MinGW64 into CYGWIN64 (64 bit)				  Not OK
		DMC compiler (32 bit only) 							      Not OK
		LCC compiler (32 bit) 									          OK
		LCC compiler (64 bit) 									          OK
		GCC compiler of MinGW "official" (32 bit) 			  OK
		GCC compiler of MinGW32 into MSYS2 (32 bit) 		  OK
		GCC compiler of MinGW64 into MSYS2 (64 bit)   Not OK
		GCC compiler of MinGW32 into WinLibs (32 bit) 	  OK
		GCC compiler of MinGW64 into WinLibs (64 bit) Not OK
		OneAPI Intel compiler (32 bit) 						    Not OK
		OneAPI Intel compiler (64 bit) 						    Not OK
		Pelles C compiler (32 bit) 								        OK
		Pelles C compiler (64 bit) 							      Not OK
		GCC compiler of MinGW64 into Red-Panda (64 bit) Not OK
		GCC compiler of TDM-32 (32 bit) 						    OK
		GCC compiler of TDM-64 (64 bit) 					    Not OK
		MSVC compiler (32 bit) 								        Not OK
		MSVC compiler (64 bit) 								        Not OK
		Open WATCOM compiler (32 bit) 						    Not OK
		Open WATCOM compiler (64 bit)						      Not OK
