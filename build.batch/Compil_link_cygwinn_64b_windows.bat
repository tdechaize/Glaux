@echo off
REM ---------------------------------------------------------------------------------------------------
REM
REM		 Compil_link_cygwinn_64b_windows.bat : 	Nom de ce batch  
REM
REM      Batch de lancement d'une générations d'une application Windows (sources C avec un fichier resource) 
REM    avec le compilateur gcc "natif" inclus dans le package CYGWIN64.
REM
REM     Dans les grands principes, on modifie certaines variables d'environnement dont le PATH Windows, afin 
REM     de pouvoir lancer une compilation du source C, du fichier de resource et enfin de l'édition de lien
REM     final qui génère l'application attendue ou du gestionnaire de librairie.
REM     Ce batch prend quatre paramètres  :
REM 				le répertoire de l'application (le 1er paramètre) qui doit contenir un sous-répertoire \src 
REm 								contenant les sources de celle-ci.
REM 				le nom de l'application (qui doit être identique au nom du fichier principal source C (main ou Winmain), 
REM 								ainsi qu'au nom du fichier des ressources -> extension ".rc")
REM					le type de génération (compilation + edition de lien/manager de librairie) attendue parmi 
REM 							la liste suivante : console|windows|lib|dll
REM					le type de génération attendue parmi la liste suivante : Debug|Release
REM
REM 	PS : la procédure "create_dir.bat" permet de créer TOUS les répertoires utiles à ces générations multiples 
REM 					(certains compilateurs ne sont pas capables de les créer ONLINE s'ils sont absents !!)
REM 
REM 	AUTHOR : 						Thierry DECHAIZE
REM     Date de création :				7 octobre 2024  
REM 	Date dernière modification : 	7 octobre 2024 -> creation de ce batch
REM 	Détails des modifications : 	Nouvelle generation avec le compilateur "natif" GCC de CYGWIN64.
REM 	Version de ce script :			1.1.0  ->  "Version majeure" . "Version mineure" . "niveau de patch"
REM
REM ---------------------------------------------------------------------------------------------------
REM set CYGWIN64=C:\cygwin64

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
cd %SOURCE_DIR%

REM    Génération d'une application [console|windows|lib|dll] (compil + link/ar) pour le compilateur gcc 64b inclus dans CYGWIN64
:CYGWIN64
SET PATH=%CYGWIN64%\bin;%PATH%
SET "INCLUDE=C:/cygwin64/usr/include"
SET "INC1=C:/cygwin64/usr/include"
SET "INC2=C:/cygwin64/usr/include/w32api"
SET "LIB==C:/cygwin64/lib"
SET "LIB1=C:/cygwin64/lib"
SET "LIB2=C:/cygwin64/lib/w32api"
SET OBJS=
if "%3"=="console" goto CONSOL
if "%3"=="windows" goto APPWIN
if "%3"=="lib" goto LIBRA
if "%3"=="dll" goto DLLA

:CONSOL
echo "GCC 64b inclus dans CYGWIN64 -> Genération console de l'application en mode : %4"
if "%4"=="Debug" goto DEBCONS
set "CFLAGS=-O2 -m64 -DNDEBUG"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         gcc %CFLAGS% -I%INC1% -I%INC2% -o objCYGWIN64/Release/%%a.o -c src/%%a.c
		 call :concat objCYGWIN64/Release/%%a.o
		 )
)
gcc %CFLAGS% -I%INC1% -I%INC2%  -o objCYGWIN64/Release/%NAME_APPLI%.o -c src/%NAME_APPLI%.c
windres -J rc -O coff -I%INC1% -I%INC2% -o objCYGWIN64/Release/%NAME_APPLI%.res -i src/%NAME_APPLI%.rc
gcc -m64 -mconsole -s -L%LIB1% -L%LIB2% objCYGWIN64/Release/%NAME_APPLI%.o objCYGWIN64/Release/%NAME_APPLI%.res -o binCYGWIN64/Release/%NAME_APPLI%.exe -lglu32 -lopengl32 -ladvapi32 -lcomdlg32 -lgdi32 -lwinmm -lkernel32
goto FIN
:DEBCONS
set "CFLAGS=-m64 -g -DDEBUG -D_DEBUG"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         gcc %CFLAGS% -I%INC1% -I%INC2% -o objCYGWIN64/Debug/%%a.o -c src/%%a.c
		 call :concat objCYGWIN64/Debug/%%a.o
		 )
)
gcc %CFLAGS% -I%INC1% -I%INC2% -o objCYGWIN64/Debug/%NAME_APPLI%.o -c src/%NAME_APPLI%.c
windres -J rc -O coff -I%INC1% -I%INC2% -o objCYGWIN64/Debug/%NAME_APPLI%.res src/%NAME_APPLI%.rc
gcc -m64 -mconsole -L%LIB1% -L%LIB2% objCYGWIN64/Debug/%NAME_APPLI%.o objCYGWIN64/Debug/%NAME_APPLI%.res -o binCYGWIN64/Debug/%NAME_APPLI%.exe -lglu32 -lopengl32 -ladvapi32 -lcomdlg32 -lgdi32 -lwinmm -lkernel32
goto FIN

:APPWIN
echo "GCC 64b inclus dans CYGWIN64 -> Genération windows de l'application en mode : %4"
if "%4"=="Debug" goto DEBAPP
set "CFLAGS=-O2 -m64 -DNDEBUG"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         gcc %CFLAGS% -I%INC1% -I%INC2% -o objCYGWIN64/Release/%%a.o -c src/%%a.c
		 call :concat objCYGWIN64/Release/%%a.o
		 )
)
gcc %CFLAGS% -I%INC1% -I%INC2% -o objCYGWIN64/Release/%NAME_APPLI%.o -c src/%NAME_APPLI%.c
windres -J rc -O coff -I%INC1% -I%INC2% -o objCYGWIN64/Release/%NAME_APPLI%.res -i src/%NAME_APPLI%.rc
gcc -m64 -mwindows -s -L%LIB1% -L%LIB2% objCYGWIN64/Release/%NAME_APPLI%.o objCYGWIN64/Release/%NAME_APPLI%.res -o binCYGWIN64/Release/%NAME_APPLI%.exe -lglu32 -lopengl32 -ladvapi32 -lcomdlg32 -lgdi32 -lwinmm -lkernel32
goto FIN
:DEBAPP
set "CFLAGS=-m64 -g -DDEBUG -D_DEBUG"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         gcc %CFLAGS% -I%INC1% -I%INC2% -o objCYGWIN64/Debug/%%a.o -c src/%%a.c
		 call :concat objCYGWIN64/Debug/%%a.o
		 )
)
gcc %CFLAGS% -I%INC1% -I%INC2% -o objCYGWIN64/Debug/%NAME_APPLI%.o -c src/%NAME_APPLI%.c
windres -J rc -O coff -I%INC1% -I%INC2% -o objCYGWIN64/Debug/%NAME_APPLI%.res src/%NAME_APPLI%.rc
gcc -m64 -mwindows -L%LIB1% -L%LIB2% objCYGWIN64/Debug/%NAME_APPLI%.o objCYGWIN64/Debug/%NAME_APPLI%.res -o binCYGWIN64/Debug/%NAME_APPLI%.exe -lglu32 -lopengl32 -ladvapi32 -lcomdlg32 -lgdi32 -lwinmm -lkernel32
goto FIN

:LIBRA
echo "GCC 64b inclus dans CYGWIN64 -> Genération d'une librairie en mode : %4"
if "%4"=="Debug" goto DEBLIB
set "CFLAGS=-O2 -m64 -DNDEBUG"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         gcc %CFLAGS% -I%INC1% -I%INC2% -o objCYGWIN64/Release/%%a.o -c src/%%a.c
		 call :concat objCYGWIN64/Release/%%a.o
		 )
)
gcc %CFLAGS% -I%INC1% -I%INC2% -o objCYGWIN64/Release/%NAME_APPLI%.o -c src/%NAME_APPLI%.c
REM windres -J rc -O coff -I%INC1% -I%INC2% -o objCYGWIN64/Release/%NAME_APPLI%.res -i src/%NAME_APPLI%.rc
ar rus binCYGWIN64/Release/lib%NAME_APPLI%.a objCYGWIN64/Release/%NAME_APPLI%.o
gcc  -L%LIB1% -L%LIB2% -o binCYGWIN64/Release/%NAME_APPLI%.lib objCYGWIN64/Release/%NAME_APPLI%.o -lglu32 -lopengl32 -ladvapi32 -lcomdlg32 -lgdi32 -lwinmm -lkernel32
goto FIN
:DEBLIB
set "CFLAGS=-m64 -g -DDEBUG -D_DEBUG"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         gcc %CFLAGS% -I%INC1% -I%INC2% -o objCYGWIN64/Debug/%%a.o -c src/%%a.c
		 call :concat objCYGWIN64/Debug/%%a.o
		 )
)
gcc %CFLAGS% -I%INC1% -I%INC2% -o objCYGWIN64/Debug/%NAME_APPLI%.o -c src/%NAME_APPLI%.c
REM windres -J rc -O coff -I%INC1% -I%INC2% -o objCYGWIN64/Debug/%NAME_APPLI%.res src/%NAME_APPLI%.rc
ar rus binCYGWIN64/Debug/lib%NAME_APPLI%.a objCYGWIN64/Debug/%NAME_APPLI%.o
gcc  -L%LIB1% -L%LIB2% -o binCYGWIN64/Debug/%NAME_APPLI%.lib objCYGWIN64/Debug/%NAME_APPLI%.o -lglu32 -lopengl32 -ladvapi32 -lcomdlg32 -lgdi32 -lwinmm -lkernel32
goto FIN

:DLLA
echo "GCC 64b inclus dans CYGWIN64 -> Genération d'une librairie partagée (.ie. DLL) en mode : %4"
if "%4"=="Debug" goto DEBDLL
set "CFLAGS=-O2 -m64 -pic -DNDEBUG"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         gcc %CFLAGS% -I%INC1% -I%INC2% -o objCYGWIN64/Release/%%a.o -c src/%%a.c
		 call :concat objCYGWIN64/Release/%%a.o
		 )
)
gcc %CFLAGS% -I%INC1% -I%INC2% -o objCYGWIN64/Release/%NAME_APPLI%.o -c src/%NAME_APPLI%.c
windres -J rc -O coff -I%INC1% -I%INC2% -o objCYGWIN64/Release/%NAME_APPLI%.res -i src/%NAME_APPLI%.rc
gcc -m64 -shared -s -L%LIB1% -L%LIB2% -Wl,--out-implib,binCYGWIN64/Release/lib%NAME_APPLI%.dll.a -W1,—export-all-symbols -Wl,—enable-auto-image-base -Wl,--subsystem,windows objCYGWIN64/Release/%NAME_APPLI%.o objCYGWIN64/Release/%NAME_APPLI%.res -o binCYGWIN64/Release/%NAME_APPLI%.dll -lglu32 -lopengl32 -ladvapi32 -lcomdlg32 -lgdi32 -lwinmm -lkernel32
goto FIN
:DEBDLL
set "CFLAGS=-m64 -g -pic -DDEBUG -D_DEBUG"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         gcc %CFLAGS% -I%INC1% -I%INC2% -o objCYGWIN64/Debug/%%a.o -c src/%%a.c
		 call :concat objCYGWIN64/Debug/%%a.o
		 )
)
gcc %CFLAGS% -I%INC1% -I%INC2% -o objCYGWIN64/Debug/%NAME_APPLI%.o -c src/%NAME_APPLI%.c
windres -J rc -O coff -I%INC1% -I%INC2% -o objCYGWIN64/Debug/%NAME_APPLI%.res src/%NAME_APPLI%.rc
gcc -m64 -shared -L%LIB1% -L%LIB2% -Wl,--out-implib,binCYGWIN64/Debug/lib%NAME_APPLI%.dll.a -W1,—export-all-symbols -Wl,—enable-auto-image-base -Wl,--subsystem,windows objCYGWIN64/Debug/%NAME_APPLI%.o objCYGWIN64/Debug/%NAME_APPLI%.res -o binCYGWIN64/Debug/%NAME_APPLI%.dll -lglu32 -lopengl32 -ladvapi32 -lcomdlg32 -lgdi32 -lwinmm -lkernel32
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
SET "INC1="
SET "INC2="
SET "LIB1="
SET "LIB2="
cd %DIRINIT%
