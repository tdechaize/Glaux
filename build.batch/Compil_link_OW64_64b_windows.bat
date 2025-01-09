@echo off
REM ---------------------------------------------------------------------------------------------------
REM
REM		 Compil_link_OW64_64b_windows.bat : 	Nom de ce batch  
REM
REM      Batch de lancement d'une générations d'une application Windows (sources C avec un fichier resource) 
REM    avec le compilateur Borland C/C++ 5.51.
REM
REM     Dans les grands principes, on modifie certaines variables d'environnement dont le PATH Windows, afin 
REM     de pouvoir lancer une compilation du source C, du fichier de resource et enfin de l'édition de lien
REM     final qui génère l'application attendue.
REM     Ce batch prend quatre paramètres  :
REM 				le répertoire des sources de l'application (le 1er paramètre),
REM 				le nom de l'application (qui doit être identique au nom du fichier principal source C (main ou Winmain), 
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
REM 	Détails des modifications : 	le paramétrage permet une certaine généricité, mais le structure des sources 
REM										est imposée sur le sous-répertoire \src : %NAME_APPLI%.c + %NAME_APPLI%.rc + *.c
REM 	Version de ce script :			1.1.3  ->  "Version majeure" . "Version mineure" . "niveau de patch"
REM
REM ---------------------------------------------------------------------------------------------------
REM set WATCOM=C:\WATCOM
  
if [%1]==[] goto usage
if [%2]==[] goto usage
if not exist %1\ goto usage
echo "Répertoire principal de l'application : %1"
echo "Nom de l'application  			: %2"

set DIRINIT=%CD%
SET PATHSAV=%PATH%
SET LIBSAV=%LIB%
SET INCSAV=%INCLUDE%
set SOURCE_DIR=%1
set NAME_APPLI=%2
cd %SOURCE_DIR%

REM    Génération d'une application [console|windows|lib|dll] (compil + link/lcclib) pour le compilateur Open Watcom C/C++ 64 bits
:OW64
SET PATH=C:\WATCOM\binnt64;%PATH%
SET INC1=C:\WATCOM\h\nt
SET INC2=C:\WATCOM\h
SET LIB1=C:\WATCOM\lib386\nt
SET LIB2=C:\WATCOM\lib386
SET OBJS=
if "%3"=="console" goto CONSOL
if "%3"=="windows" goto APPWIN
if "%3"=="lib" goto LIBRA
if "%3"=="dll" goto DLLA

:CONSOL
echo "Open Watcom C/C++ 64bits -> Genération console de l'application en mode : %4"
if "%4"=="Debug" goto DEBCONS
set "CFLAGS=-q -c -bt=nt -dNDEBUG -d_WIN64"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         wcl386 %CFLAGS% -i%INC1% -i%INC2% -fo=objOW64\Release\%%a.obj src\%%a.c
		 call :concat objOW64\Release\%%a.o
		 )
)
wcl386 %CFLAGS% -i%INC1% -i%INC2% -fo=objOW64\Release\%NAME_APPLI%.obj src\%NAME_APPLI%.c
wrc -q -r -i%INC1% -i%INC2% -fo=objOW64\Release\%NAME_APPLI%.res src\%NAME_APPLI%.rc
wlink option quiet system nt LIBP "%LIB1%";"%LIB2%" file %OBJS% objOW64\Release\%NAME_APPLI%.obj option resource=objOW64\Release\%NAME_APPLI%.res name binOW64\Release\%NAME_APPLI%.exe library glu32,opengl32,advapi32,comdlg32,gdi32,winmm,user32,kernel32
goto FIN
:DEBCONS
set "CFLAGS=-q -c  -d2 -g -bt=nt -dDEBUG -d_DEBUG -d_WIN64"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         wcl386 %CFLAGS% -i%INC1% -i%INC2% -fo=objOW64\Debug\%%a.obj src\%%a.c
		 call :concat objOW64\Debug\%%a.o
		 )
)
wcl386 %CFLAGS% -i%INC1% -i%INC2% -fo=objOW64\Debug\%NAME_APPLI%.obj src\%NAME_APPLI%.c
wrc -q -r -i%INC1% -i%INC2% -fo=objOW64\Debug\%NAME_APPLI%.res src\%NAME_APPLI%.rc
wlink option quiet debug all system nt LIBP "%LIB1%";"%LIB2%" file %OBJS% objOW64\Debug\%NAME_APPLI%.obj option resource=objOW64\Debug\%NAME_APPLI%.res name binOW64\Debug\%NAME_APPLI%.exe library glu32,opengl32,advapi32,comdlg32,gdi32,winmm,user32,kernel32
goto FIN

:APPWIN
echo "Open Watcom C/C++ 64bits -> Genération windows de l'application en mode : %4"
if "%4"=="Debug" goto DEBAPP
set "CFLAGS=-q -c -bt=nt -dNDEBUG -d_WIN64"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         wcl386 %CFLAGS% -i%INC1% -i%INC2% -fo=objOW64\Release\%%a.obj src\%%a.c
		 call :concat objOW64\Release\%%a.o
		 )
)
wcl386 %CFLAGS% -i%INC1% -i%INC2% -fo=objOW64\Release\%NAME_APPLI%.obj src\%NAME_APPLI%.c
wrc -q -r -i%INC1% -i%INC2% -fo=objOW64\Release\%NAME_APPLI%.res src\%NAME_APPLI%.rc
wlink option quiet system nt_win  LIBP "%LIB1%";"%LIB2%" file %OBJS% objOW64\Release\%NAME_APPLI%.obj option resource=objOW64\Release\%NAME_APPLI%.res name binOW64\Release\%NAME_APPLI%.exe library glu32,opengl32,advapi32,comdlg32,gdi32,winmm,user32,kernel32
goto FIN
:DEBAPP
set "CFLAGS=-q -c  -d2 -g -bt=nt -dDEBUG -d_DEBUG -d_WIN64"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         wcl386 %CFLAGS% -i%INC1% -i%INC2% -fo=objOW64\Debug\%%a.obj src\%%a.c
		 call :concat objOW64\Debug\%%a.o
		 )
)
wcl386 %CFLAGS% -i%INC1% -i%INC2% -fo=objOW64\Debug\%NAME_APPLI%.obj src\%NAME_APPLI%.c
wrc -q -r -i%INC1% -i%INC2% -fo=objOW64\Debug\%NAME_APPLI%.res src\%NAME_APPLI%.rc
wlink option quiet debug all system nt_win  LIBP "%LIB1%";"%LIB2%" file %OBJS% objOW64\Debug\%NAME_APPLI%.obj option resource=objOW64\Debug\%NAME_APPLI%.res name binOW64\Debug\%NAME_APPLI%.exe library glu32,opengl32,advapi32,comdlg32,gdi32,winmm,user32,kernel32
goto FIN

:LIBRA
echo "Open Watcom C/C++ 64bits -> Genération d'une librairie en mode : %4"
if "%4"=="Debug" goto DEBLIB
set "CFLAGS=-q -c -bt=nt -dNDEBUG -d_WIN64"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         wcl386 %CFLAGS% -i%INC1% -i%INC2% -fo=objOW64\Release\%%a.obj src\%%a.c
		 call :concat objOW64\Release\%%a.o
		 )
)
wcl386 %CFLAGS% -i%INC1% -i%INC2% -fo=objOW64\Release\%NAME_APPLI%.obj src\%NAME_APPLI%.c
REM wrc -q -r -i%INC1% -i%INC2% -fo=objOW64\Release\%NAME_APPLI%.res src\%NAME_APPLI%.rc
wlib -q -i6 -ic binOW64\Release\%NAME_APPLI%.lib +-objOW64\Release\%NAME_APPLI%.obj  +%OBJS%
goto FIN
:DEBLIB
set "CFLAGS=-q -c  -d2 -g -bt=nt -dDEBUG -d_DEBUG -d_WIN64"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         wcl386 %CFLAGS% -i%INC1% -i%INC2% -fo=objOW64\Debug\%%a.obj src\%%a.c
		 call :concat objOW64\Debug\%%a.o
		 )
)
wcl386 %CFLAGS% -i%INC1% -i%INC2% -fo=objOW64\Debug\%NAME_APPLI%.obj src\%NAME_APPLI%.c
REM wrc -q -r -i%INC1% -i%INC2% -fo=objOW64\Debug\%NAME_APPLI%.res src\%NAME_APPLI%.rc
wlib -q -i6 -ic binOW64\Debug\%NAME_APPLI%.lib +-objOW64\Debug\%NAME_APPLI%.obj  +%OBJS%
goto FIN

:DLLA
echo "Open Watcom C/C++ 64bits -> Genération d'une librairie partagée (.ie. DLL) en mode : %4"
if "%4"=="Debug" goto DEBDLL
set "FLAGS=-q -c -bt=nt -dNDEBUG -d_WIN64"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         wcl386 %CFLAGS% -i%INC1% -i%INC2% -fo=objOW64\Release\%%a.obj src\%%a.c
		 call :concat objOW64\Release\%%a.o
		 )
)
wcl386 %CFLAGS% -i%INC1% -i%INC2% -fo=objOW64\Release\%NAME_APPLI%.obj src\%NAME_APPLI%.c
wrc -q -r -i%INC1% -i%INC2% -fo=objOW64\Release\%NAME_APPLI%.res src\%NAME_APPLI%.rc
wlink option quiet system nt_win DLL LIBP "%LIB1%";"%LIB2%"  IMPLIB binOW64\Release\%NAME_APPLI%.lib file %OBJS% objOW64\Release\%NAME_APPLI%.obj option resource=objOW64\Release\%NAME_APPLI%.res name binOW64\Release\%NAME_APPLI%.dll library glu32,opengl32,advapi32,comdlg32,gdi32,winmm,user32,kernel32
goto FIN
:DEBDLL
set "FLAGS=-q -c  -d2 -g -bt=nt -dDEBUG -d_DEBUG -d_WIN64"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         wcl386 %CFLAGS% -i%INC1% -i%INC2% -fo=objOW64\Debug\%%a.obj src\%%a.c
		 call :concat objOW64\Debug\%%a.o
		 )
)
wcl386 %CFLAGS% -i%INC1% -i%INC2% -fo=objOW64\Debug\%NAME_APPLI%.obj src\%NAME_APPLI%.c
wrc -q -r -i%INC1% -i%INC2% -fo=objOW64\Debug\%NAME_APPLI%.res src\%NAME_APPLI%.rc
wlink option quiet debug all system nt_win DLL LIBP "%LIB1%";"%LIB2%"  IMPLIB binOW64\Debug\%NAME_APPLI%.lib file %OBJS% objOW64\Debug\%NAME_APPLI%.obj option resource=objOW64\Debug\%NAME_APPLI%.res name binOW64\Debug\%NAME_APPLI%.dll library glu32,opengl32,advapi32,comdlg32,gdi32,winmm,user32,kernel32
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
SET INC1=""
SET INC2=""
SET LIB1=""
SET LIB2=""
cd %DIRINIT%