@echo off
REM ---------------------------------------------------------------------------------------------------
REM
REM		 Compil_link_Borland_32b_windows.bat : 	Nom de ce batch  
REM
REM      Batch de lancement d'une générations d'une application Windows (source C avec un fichier resource) 
REM    avec le compilateur Borland C/C++ 5.51.
REM
REM     Dans les grands principes, on modifie certaines variables d'environnement dont le PATH Windows, afin 
REM     de pouvoir lancer une compilation du source C, du fichier de resource et enfin de l'édition de lien
REM     final qui génère l'application attendue.
REM     Ce batch prend quatre paramètres  :
REM 				le répertoire des sources de l'application (le 1er paramètre),
REM 				le nom de l'application (qui doit être identique au nom du fichier principal source C, 
REM 								ainsi qu'au nom du fichier des ressources -> extension ".rc")
REM					le type de génération (compilation + linkage/manager de librairie) attendue parmi la 
REM									liste suivante : console|windows|lib|dll
REM					la catégorie de génération attendue parmi la liste suivante : Debug|Release
REM
REM 	PS : la procédure "create_dir.bat" permet de créer TOUS les répertoires utiles à ces générations multiples 
REM 					(certains compilateurs ne sont pas capables de les créer ONLINE s'ils sont absents !!)
REM 
REM 	AUTHOR : 						Thierry DECHAIZE
REM     Date de création :				26 Septembre 2022   
REM 	Date dernière modification : 	27 février 2023 -> s'il existe un fichier src_c.txt c'est que l'application est composée de plusieurs fichiers source en C => on compile alors chacun de ces fichiers
REM 	Détails des modifications : 	le paramétrage permet une certaine généricité, mais le structure des sources est imposée sur le sous-répertoire %1\src : %NAME_APPLI%.c + %NAME_APPLI%.rc + *.c
REM 	Version de ce script :			1.1.3  ->  "Version majeure" . "Version mineure" . "niveau de patch"
REM
REM ---------------------------------------------------------------------------------------------------
  
if [%1]==[] goto usage
if [%2]==[] goto usage
if not exist %1\ goto usage
echo "Répertoire principal de l'application : %1"
echo "Nom de l'application  				: %2"

set DIRINIT=%CD%
SET PATHSAV=%PATH%
SET LIBSAV=%LIB%
SET INCSAV=%INCLUDE%
set SOURCE_DIR=%1
set NAME_APPLI=%2
cd %1
@echo on

REM    Génération d'une application [console|windows|lib|dll] (compil + link/tlib) pour le compilateur Borland C/C++ 5.51 
:BCC
@setlocal enableextensions enabledelayedexpansion  
SET PATH=C:\BCC55\bin;%PATH%
SET INCLUDE=C:\BCC55\include
SET LIB1=C:\BCC55\lib\PSDK
set LIB2=C:\BCC55\lib
SET OBJS=
if "%3"=="console" goto CONSOL
if "%3"=="windows" goto APPWIN
if "%3"=="lib" goto LIBRA
if "%3"=="dll" goto DLLA

:CONSOL
echo "Borland C/C++ 5.5 -> Genération console de l'application en mode : %4"
if "%4"=="Debug" goto DEBCONS
set "CFLAGS=-c -w -w-par -w-inl -W -a1 -O2 -6"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         bcc32 -c -DNDEBUG -I%INCLUDE% -oobjBC55\Release\%%a.obj src\%%a.c
		 call :concat objBC55\Release\%%a.obj
		 )
)
bcc32 %CFLAGS% -DNDEBUG -I%INCLUDE% -oobjBC55\Release\%NAME_APPLI%.obj src\%NAME_APPLI%.c
brcc32 -32 -i%INCLUDE% -foobjBC55\Release\%NAME_APPLI%.res src\%NAME_APPLI%.rc
if exist %1\src_c.txt (
ilink32 -q -aa -V4.0 -c -x -Gn -L"%LIB1%" -L"%LIB2%" c0x32w.obj %OBJS% objBC55\Release\%NAME_APPLI%.obj, binBC55\Release\%NAME_APPLI%.exe, , import32.lib cw32.lib opengl32.lib gdi32.lib advapi32.lib comdlg32.lib winmm.lib user32.lib kernel32.lib, ,objBC55\Release\%NAME_APPLI%.res
) else (
ilink32 -q -aa -V4.0 -c -x -Gn -L"%LIB1%" -L"%LIB2%" c0x32w.obj objBC55\Release\%NAME_APPLI%.obj, binBC55\Release\%NAME_APPLI%.exe, , import32.lib cw32.lib opengl32.lib gdi32.lib advapi32.lib comdlg32.lib winmm.lib user32.lib kernel32.lib, ,objBC55\Release\%NAME_APPLI%.res
)
goto FIN
:DEBCONS
set "CFLAGS=-c -w -w-par -w-inl -W -a1 -O2 -6 -v"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         bcc32 -c -DDEBUG -D_DEBUG -I%INCLUDE% -oobjBC55\Debug\%%a.obj src\%%a.c
		 call :concat objBC55\Debug\%%a.obj
		 )
)
bcc32 %CFLAGS% -DDEBUG -D_DEBUG -I%INCLUDE% -oobjBC55\Debug\%NAME_APPLI%.obj src\%NAME_APPLI%.c
brcc32 -32 -i%INCLUDE% -foobjBC55\Debug\%NAME_APPLI%.res src\%NAME_APPLI%.rc
if exist %1\src_c.txt (
ilink32 -q -aa -V4.0 -c -x -Gn -L"%LIB1%" -L"%LIB2%" c0x32w.obj %OBJS% objBC55\Debug\%NAME_APPLI%.obj, binBC55\Debug\%NAME_APPLI%.exe, , import32.lib cw32.lib opengl32.lib gdi32.lib advapi32.lib comdlg32.lib winmm.lib user32.lib kernel32.lib, ,objBC55\Debug\%NAME_APPLI%.res
) else (
ilink32 -q -aa -V4.0 -c -x -Gn -L"%LIB1%" -L"%LIB2%" c0x32w.obj objBC55\Debug\%NAME_APPLI%.obj, binBC55\Debug\%NAME_APPLI%.exe, , import32.lib cw32.lib opengl32.lib gdi32.lib advapi32.lib comdlg32.lib winmm.lib user32.lib kernel32.lib, ,objBC55\Debug\%NAME_APPLI%.res
)
goto FIN

:APPWIN
echo "Borland C/C++ 5.5 -> Genération windows de l'application en mode : %4"
if "%4"=="Debug" goto DEBAPP
set "CFLAGS=-c -tWM -w -w-par -w-inl -W -a1 -O2 -6"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         bcc32 -c -DNDEBUG -I%INCLUDE% -oobjBC55\Release\%%a.obj src\%%a.c
		 call :concat objBC55\Release\%%a.obj
		 )
)
bcc32 %CFLAGS% -DNDEBUG -I%INCLUDE% -oobjBC55\Release\%NAME_APPLI%.obj src\%NAME_APPLI%.c
brcc32 -32 -i%INCLUDE% -foobjBC55\Release\%NAME_APPLI%.res src\%NAME_APPLI%.rc
if exist %1\src_c.txt (
ilink32 -q -aa -V4.0 -c -x -Gn -L"%LIB1%" -L"%LIB2%" c0w32.obj %OBJS% objBC55\Release\%NAME_APPLI%.obj, binBC55\Release\%NAME_APPLI%.exe, , import32.lib cw32.lib opengl32.lib gdi32.lib advapi32.lib comdlg32.lib winmm.lib user32.lib kernel32.lib, ,objBC55\Release\%NAME_APPLI%.res
) else (
ilink32 -q -aa -V4.0 -c -x -Gn -L"%LIB1%" -L"%LIB2%" c0w32.obj objBC55\Release\%NAME_APPLI%.obj, binBC55\Release\%NAME_APPLI%.exe, , import32.lib cw32.lib opengl32.lib gdi32.lib advapi32.lib comdlg32.lib winmm.lib user32.lib kernel32.lib, ,objBC55\Release\%NAME_APPLI%.res
)
goto FIN
:DEBAPP
set "CFLAGS=-c -tWM -w -w-par -w-inl -W -a1 -O2 -6 -v"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         bcc32 -c -DDEBUG -D_DEBUG -I%INCLUDE% -oobjBC55\Debug\%%a.obj src\%%a.c
		 call :concat objBC55\Debug\%%a.obj
		 )
)
bcc32 %CFLAGS% -DDEBUG -D_DEBUG -I%INCLUDE% -oobjBC55\Debug\%NAME_APPLI%.obj src\%NAME_APPLI%.c
brcc32 -32 -i%INCLUDE% -foobjBC55\Debug\%NAME_APPLI%.res src\%NAME_APPLI%.rc
if exist %1\src_c.txt (
ilink32 -q -aa -V4.0 -c -x -Gn -L"%LIB1%" -L"%LIB2%" c0w32.obj %OBJS% objBC55\Debug\%NAME_APPLI%.obj, binBC55\Debug\%NAME_APPLI%.exe, , import32.lib cw32.lib opengl32.lib gdi32.lib advapi32.lib comdlg32.lib winmm.lib user32.lib kernel32.lib, ,objBC55\Debug\%NAME_APPLI%.res
) else (
ilink32 -q -aa -V4.0 -c -x -Gn -L"%LIB1%" -L"%LIB2%" c0w32.obj objBC55\Debug\%NAME_APPLI%.obj, binBC55\Debug\%NAME_APPLI%.exe, , import32.lib cw32.lib opengl32.lib gdi32.lib advapi32.lib comdlg32.lib winmm.lib user32.lib kernel32.lib, ,objBC55\Debug\%NAME_APPLI%.res
)
goto FIN

:LIBRA
echo "Borland C/C++ 5.5 -> Genération d'une librairie en mode : %4"
if "%4"=="Debug" goto DEBLIB
set "CFLAGS=-c -w -w-par -w-inl -W -a1 -O2 -6"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         bcc32 -c -DNDEBUG -I%INCLUDE% -oobjBC55\Release\%%a.obj src\%%a.c
		 )
)
bcc32 %CFLAGS% -DNDEBUG -I%INCLUDE% -oobjBC55\Release\%NAME_APPLI%.obj src\%NAME_APPLI%.c
REM brcc32 -32 -i%INCLUDE% -foobjBC55\Release\%NAME_APPLI%.res src\%NAME_APPLI%.rc
dir /a-d /b objBC55\Release > lst_obj.txt
for /f "tokens=* delims=" %%a in ('type lst_obj.txt') do (	
tlib binBC55\Release\%NAME_APPLI%.lib +objBC55\Release\%%a
)
if exist lst_obj.txt del lst_obj.txt
goto FIN
:DEBLIB
set "CFLAGS=-c -w -w-par -w-inl -W -a1 -O2 -6 -v"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         bcc32 -c -DNDEBUG -I%INCLUDE% -oobjBC55\Debug\%%a.obj src\%%a.c
		 )
)
bcc32 %CFLAGS% -DDEBUG -D_DEBUG -I%INCLUDE% -oobjBC55\Debug\%NAME_APPLI%.obj src\%NAME_APPLI%.c
REM brcc32 -32 -i%INCLUDE% -foobjBC55\Debug\%NAME_APPLI%.res src\%NAME_APPLI%.rc
dir /a-d /b objBC55\Debug > lst_obj.txt
for /f "tokens=* delims=" %%a in ('type lst_obj.txt') do (	
tlib binBC55\Debug\%NAME_APPLI%.lib +objBC55\Debug\%%a
)
if exist lst_obj.txt del lst_obj.txt
goto FIN

REM   	 ilink32 -Tpd -aa -V4.0 -c -x c0d32.obj, myresource.dll , ,import32.lib cw32i.lib, ,myresource.res
REM 	The linker is more complex and takes several parameters.
REM 
REM	Parameter 			Meaning
REM 	-Tpd 			This tells the linker the type of file you want to create. You can use -Tpe to create an exe.
REM 	-aa 			This tells the linker that this will be a 32 bit Windows application.
REM   	-V4.0 			This specifies the target Windows version that this DLL will be used for. 4.0 represents Windows 95 and later.
REM  	-c 				This tells the linker that you want case sensitive symbols.  I'm not sure that this is critical but since C is case sensitive it's a good idea to include it.
REM  	-x 				This suppresses the creation of a MAP file. A MAP file is a text file which list all the memory locations of the symbols of a C program. Since this is simply a resource file we're making, it's not that useful to have a MAP file.
REM  	c0d32.obj 		This object file is required to link into the dll. It allows the DLL to be loaded into memory only when needed.
REM  	myresource.dll 	This is the output DLL file that will be created.
REM 	import32.lib and cw32i.lib 	These libraries are needed for the DLL. They're used to access the Windows API.
REM 	myresource.res 	This is your compiled RES file that will be linked into dll.
REM  	  	 
REM     Notice in the command line that there are items seperated by commas. One part of the command line has 2 commas with nothing in between. This part of the command line is for dependency files (.DEP) which we don’t need for a dll. 

:DLLA
echo "Borland C/C++ 5.5 -> Genération d'une librairie partagée (.ie. DLL) en mode : %4"
if "%4"=="Debug" goto DEBDLL
set "FLAGS=-c -w -w-par -w-inl -W -a1 -O2 -6"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         bcc32 -c -DNDEBUG -I%INCLUDE% -oobjBC55\Release\%%a.obj src\%%a.c
		 call :concat objBC55\Release\%%a.obj
		 )
)
bcc32 %CFLAGS% -DNDEBUG -I%INCLUDE% -oobjBC55\Release\%NAME_APPLI%.obj src\%NAME_APPLI%.c
brcc32 -32 -i%INCLUDE% -foobjBC55\Release\%NAME_APPLI%.res src\%NAME_APPLI%.rc
if exist %1\src_c.txt (
ilink32 -q -Tpd -aa -V4.0 -c -x -Gi -L"%LIB1%" -L"%LIB2%" c0d32.obj %OBJS% objBC55\Release\%NAME_APPLI%.obj, binBC55\Release\%NAME_APPLI%.dll, , import32.lib cw32i.lib opengl32.lib gdi32.lib advapi32.lib comdlg32.lib winmm.lib user32.lib kernel32.lib, ,objBC55\Release\%NAME_APPLI%.res
implib -c binBC55\Release\%NAME_APPLI%.lib binBC55\Release\%NAME_APPLI%.dll
) else (
ilink32 -q -Tpd -aa -V4.0 -c -x -Gi -L"%LIB1%" -L"%LIB2%" c0d32.obj objBC55\Release\%NAME_APPLI%.obj, binBC55\Release\%NAME_APPLI%.dll, , import32.lib cw32i.lib opengl32.lib gdi32.lib advapi32.lib comdlg32.lib winmm.lib user32.lib kernel32.lib, ,objBC55\Release\%NAME_APPLI%.res
implib -c binBC55\Release\%NAME_APPLI%.lib binBC55\Release\%NAME_APPLI%.dll
)
goto FIN
:DEBDLL
set "FLAGS=-c -w -w-par -w-inl -W -a1 -O2 -6 -v"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         bcc32 -c -DDEBUG -D_DEBUG  -I%INCLUDE% -oobjBC55\Debug\%%a.obj src\%%a.c
		 call :concat objBC55\Debug\%%a.obj
		 )
)
bcc32 %CFLAGS% -DDEBUG -D_DEBUG -I%INCLUDE% -oobjBC55\Debug\%NAME_APPLI%.obj src\%NAME_APPLI%.c
brcc32 -32 -i%INCLUDE% -foobjBC55\Debug\%NAME_APPLI%.res src\%NAME_APPLI%.rc
if exist %1\src_c.txt (
ilink32 -q -Tpd -aa -V4.0 -c -x -Gi -L"%LIB1%" -L"%LIB2%" c0d32.obj %OBJS% objBC55\Debug\%NAME_APPLI%.obj, binBC55\Debug\%NAME_APPLI%.dll, , import32.lib cw32.lib glu32.lib opengl32.lib gdi32.lib advapi32.lib comdlg32.lib winmm.lib user32.lib kernel32.lib, ,objBC55\Debug\%NAME_APPLI%.res
implib -c binBC55\Debug\%NAME_APPLI%.lib binBC55\Debug\%NAME_APPLI%.dll
) else (
ilink32 -q -Tpd -aa -V4.0 -c -x -Gi -L"%LIB1%" -L"%LIB2%" c0d32.obj objBC55\Debug\%NAME_APPLI%.obj, binBC55\Debug\%NAME_APPLI%.dll, , import32.lib cw32.lib glu32.lib opengl32.lib gdi32.lib advapi32.lib comdlg32.lib winmm.lib user32.lib kernel32.lib, ,objBC55\Debug\%NAME_APPLI%.res
implib -c binBC55\Debug\%NAME_APPLI%.lib binBC55\Debug\%NAME_APPLI%.dll
)
goto FIN

:concat
set OBJS=%~1 %OBJS%
EXIT /B

:usage
echo "Usage : %0 DIRECTORY_APPLI NAME_APPLI console|windows|lib|dll Debug|Release"
echo "et si pas de deuxième paramètre, affichage de cette explication d'usage"
echo "ou alors, le répertoire des sources n'existe pas ... !"
 
:FIN
SET INCLUDE=%INCSAV%
SET LIB=%LIBSAV%
SET PATH=%PATHSAV%
SET LIB1=""
set LIB2=""
cd %DIRINIT%
endlocal