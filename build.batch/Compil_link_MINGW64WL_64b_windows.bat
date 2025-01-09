@echo off
REM ---------------------------------------------------------------------------------------------------
REM
REM		 Compil_link_MINGW64WL_32b_windows.bat : 	Nom de ce batch  
REM
REM      Batch de lancement d'une génération d'une application Windows (source C avec un fichier resource) 
REM    avec le compilateur GCC inclus dans le package Mingw64 lui même associé à l'IDE Code::Blocks.
REM
REM     Dans les grands principes, on modifie certaines variables d'environnement dont le PATH Windows, afin 
REM     de pouvoir lancer une compilation du source C, du fichier de resource et enfin de l'édition de lien
REM     final qui génère l'application attendue ou du gestionnaire de librairie.
REM     Ce batch prend quatre paramètres  :
REM 				le répertoire de l'application (le 1er paramètre) qui doit contenir un sous-répertoire \src 
REM 								contenant les sources de celle-ci.
REM 				le nom de l'application (qui doit être identique au nom du fichier source C, 
REM 								ainsi qu'au nom du fichier des ressources -> extension ".rc")
REM					le type de génération (compilation + edition de lien/manager de librairie) attendue parmi 
REM 							la liste suivante : console|windows|lib|dll
REM					le type de génération attendue parmi la liste suivante : Debug|Release
REM
REM 	PS : la procédure "create_dir.bat" permet de créer TOUS les répertoires utiles à ces générations multiples 
REM 			(certains compilateurs ne sont pas capables de les créer ONLINE s'ils sont absents !!)
REM 
REM 	AUTHOR : 						Thierry DECHAIZE
REM     Date de création :				29 Septembre 2022   
REM 	Date dernière modification : 	27 février 2023 -> s'il existe un fichier src_c.txt c'est que l'application est composée de plusieurs fichiers source en C => on compile alors chacun de ces fichiers
REM 	Détails des modifications : 	le paramétrage permet une certaine généricité, mais la structure des sources 
REM 									est imposée sur le sous-répertoire \src : %NAME_APPLI%.c + %NAME_APPLI%.rc + *.c
REM 	Version de ce script :			1.1.3  ->  "Version majeure" . "Version mineure" . "niveau de patch"
REM
REM ---------------------------------------------------------------------------------------------------
REM set MINGW64=C:\MinGW64

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

REM    Génération d'une application [console|windows|lib|dll] (compil + link/ar) pour le compilateur GCC (MingW64 de CB)
:MINGW64CB
set PATH=%MinGW64%\bin;%PATH%
set INCLUDE=%MinGW64%\i686-w64-mingw32\include
set LIB=%MinGW64%\i686-w64-mingw32\lib
SET OBJS=
if "%3"=="console" goto CONSOL
if "%3"=="windows" goto APPWIN
if "%3"=="lib" goto LIBRA
if "%3"=="dll" goto DLLA

:CONSOL
echo "GCC 64b Mingw64 packagé Winlibs -> Genération console de l'application en mode : %4"
if "%4"=="Debug" goto DEBCONS
set "CFLAGS=-O2 -m64"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         gcc %CFLAGS% -DNDEBUG -I%INCLUDE% -o objMINGW64WL\Release\%%a.o -c src\%%a.c
		 call :concat objMINGW64WL\Release\%%a.o
		 )
)
gcc %CFLAGS% -DNDEBUG -I%INCLUDE% -o objMINGW64WL\Release\%NAME_APPLI%.o -c src\%NAME_APPLI%.c
windres -J rc -O coff -I%INCLUDE% -o objMINGW64WL\Release\%NAME_APPLI%.res -i src\%NAME_APPLI%.rc
gcc -m64 -mconsole -s -L"%LIB%" %OBJS% objMINGW64WL\Release\%NAME_APPLI%.o objMINGW64WL\Release\%NAME_APPLI%.res -o binMINGW64WL\Release\%NAME_APPLI%.exe -lglu32 -lopengl32 -ladvapi32 -lcomdlg32 -lgdi32 -lwinmm -lkernel32
goto FIN
:DEBCONS
set "CFLAGS=-m64 -g"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         gcc %CFLAGS% -DDEBUG -D_DEBUG -I%INCLUDE% -o objMINGW64WL\Debug\%%a.o -c src\%%a.c
		 call :concat objMINGW64WL\Debug\%%a.o
		 )
)
gcc %CFLAGS% -DDEBUG -D_DEBUG -I%INCLUDE% -o objMINGW64WL\Debug\%NAME_APPLI%.o -c src\%NAME_APPLI%.c
windres -J rc -O coff -I%INCLUDE% -o objMINGW64WL\Debug\%NAME_APPLI%.res src\%NAME_APPLI%.rc
gcc -m64 -mconsole -L"%LIB%" %OBJS% objMINGW64WL\Debug\%NAME_APPLI%.o objMINGW64WL\Debug\%NAME_APPLI%.res -o binMINGW64WL\Debug\%NAME_APPLI%.exe -lglu32 -lopengl32 -ladvapi32 -lcomdlg32 -lgdi32 -lwinmm -lkernel32
goto FIN

:APPWIN
echo "GCC 64b Mingw64 packagé Winlibs -> Genération windows de l'application en mode : %4"
if "%4"=="Debug" goto DEBAPP
set "CFLAGS=-O2 -m64"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         gcc %CFLAGS% -DNDEBUG -I%INCLUDE% -o objMINGW64WL\Release\%%a.o -c src\%%a.c
		 call :concat objMINGW64WL\Release\%%a.o
		 )
)
gcc %CFLAGS% -DNDEBUG -I%INCLUDE% -o objMINGW64WL\Release\%NAME_APPLI%.o -c src\%NAME_APPLI%.c
windres -J rc -O coff -I%INCLUDE% -o objMINGW64WL\Release\%NAME_APPLI%.res -i src\%NAME_APPLI%.rc
gcc -m64 -mwindows -s -L"%LIB%" %OBJS% objMINGW64WL\Release\%NAME_APPLI%.o objMINGW64WL\Release\%NAME_APPLI%.res -o binMINGW64WL\Release\%NAME_APPLI%.exe -lglu32 -lopengl32 -ladvapi32 -lcomdlg32 -lgdi32 -lwinmm -lkernel32
goto FIN
:DEBAPP
set "CFLAGS=-m64 -g"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         gcc %CFLAGS% -DDEBUG -D_DEBUG -I%INCLUDE% -o objMINGW64WL\Debug\%%a.o -c src\%%a.c
		 call :concat objMINGW64WL\Debug\%%a.o
		 )
)
gcc %CFLAGS% -DDEBUG -D_DEBUG -I%INCLUDE% -o objMINGW64WL\Debug\%NAME_APPLI%.o -c src\%NAME_APPLI%.c
windres -J rc -O coff -I%INCLUDE% -o objMINGW64WL\Debug\%NAME_APPLI%.res src\%NAME_APPLI%.rc
gcc -m64 -mwindows -L"%LIB%" %OBJS% objMINGW64WL\Debug\%NAME_APPLI%.o objMINGW64WL\Debug\%NAME_APPLI%.res -o binMINGW64WL\Debug\%NAME_APPLI%.exe -lglu32 -lopengl32 -ladvapi32 -lcomdlg32 -lgdi32 -lwinmm -lkernel32
goto FIN

:LIBRA
echo "GCC 64b Mingw64 packagé Winlibs -> Genération d'une librairie en mode : %4"
if "%4"=="Debug" goto DEBLIB
set "CFLAGS=-O2 -m64"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         gcc %CFLAGS% -DNDEBUG -I%INCLUDE% -o objMINGW64WL\Release\%%a.o -c src\%%a.c
		 call :concat objMINGW64WL\Release\%%a.o
		 )
)
gcc %CFLAGS% -DNDEBUG -I%INCLUDE% -o objMINGW64WL\Release\%NAME_APPLI%.o -c src\%NAME_APPLI%.c
REM windres -J rc -O coff -I%INCLUDE% -o objMINGW64WL\Release\%NAME_APPLI%.res -i src\%NAME_APPLI%.rc
ar ru binMINGW64WL\Release\lib%NAME_APPLI%.a %OBJS% objMINGW64WL\Release\%NAME_APPLI%.o
gcc -m64 -o binMINGW64WL\Release\%NAME_APPLI%.lib %OBJS% objMINGW64WL\Release\%NAME_APPLI%.o -lglu32 -lopengl32 -ladvapi32 -lcomdlg32 -lgdi32 -lwinmm -lkernel32
goto FIN
:DEBLIB
set "CFLAGS=-m64 -g"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         gcc %CFLAGS% -DDEBUG -D_DEBUG -I%INCLUDE% -o objMINGW64WL\Debug\%%a.o -c src\%%a.c
		 call :concat objMINGW64WL\Debug\%%a.o
		 )
)
gcc %CFLAGS% -DDEBUG -D_DEBUG -I%INCLUDE% -o objMINGW64WL\Debug\%NAME_APPLI%.o -c src\%NAME_APPLI%.c
REM windres -J rc -O coff -I%INCLUDE% -o objMINGW64WL\Debug\%NAME_APPLI%.res src\%NAME_APPLI%.rc
ar ru binMINGW64WL\Debug\lib%NAME_APPLI%.a %OBJS% objMINGW64WL\Debug\%NAME_APPLI%.o
gcc -m64 -o binMINGW64WL\Debug\%NAME_APPLI%.lib %OBJS% objMINGW64WL\Debug\%NAME_APPLI%.o -lglu32 -lopengl32 -ladvapi32 -lcomdlg32 -lgdi32 -lwinmm -lkernel32
goto FIN

:DLLA
echo "GCC 64b Mingw64 packagé Winlibs -> Genération d'une librairie partagée (.ie. DLL) en mode : %4"
if "%4"=="Debug" goto DEBDLL
set "CFLAGS=-O2 -m64 -fPIC"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         gcc %CFLAGS% -DNDEBUG -I%INCLUDE% -o objMINGW64WL\Release\%%a.o -c src\%%a.c
		 call :concat objMINGW64WL\Release\%%a.o
		 )
)
gcc %CFLAGS% -DNDEBUG -I%INCLUDE% -o objMINGW64WL\Release\%NAME_APPLI%.o -c src\%NAME_APPLI%.c
windres -J rc -O coff -I%INCLUDE% -o objMINGW64WL\Release\%NAME_APPLI%.res -i src\%NAME_APPLI%.rc
gcc -m64 -shared -s -L"%LIB%" -Wl,--out-implib,binMINGW64WL\Release\lib%NAME_APPLI%.a -W1,—export-all-symbols -Wl,—enable-auto-image-base -Wl,--subsystem,windows %OBJS% objMINGW64WL\Release\%NAME_APPLI%.o objMINGW64WL\Release\%NAME_APPLI%.res -o binMINGW64WL\Release\%NAME_APPLI%.dll -lglu32 -lopengl32 -ladvapi32 -lcomdlg32 -lgdi32 -lwinmm -lkernel32
goto FIN
:DEBDLL
set "CFLAGS=-m64 -g -fPIC"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         gcc %CFLAGS% -DDEBUG -D_DEBUG -I%INCLUDE% -o objMINGW64WL\Debug\%%a.o -c src\%%a.c
		 call :concat objMINGW64WL\Debug\%%a.o
		 )
)
gcc %CFLAGS% -DDEBUG -D_DEBUG -I%INCLUDE% -o objMINGW64WL\Debug\%NAME_APPLI%.o -c src\%NAME_APPLI%.c
windres -J rc -O coff -I%INCLUDE% -o objMINGW64WL\Debug\%NAME_APPLI%.res src\%NAME_APPLI%.rc
gcc -m64 -shared -L"%LIB%" -Wl,--out-implib,binMINGW64WL\Debug\lib%NAME_APPLI%.a -W1,—export-all-symbols -Wl,—enable-auto-image-base -Wl,--subsystem,windows %OBJS% objMINGW64WL\Debug\%NAME_APPLI%.o objMINGW64WL\Debug\%NAME_APPLI%.res -o binMINGW64WL\Debug\%NAME_APPLI%.dll -lglu32 -lopengl32 -ladvapi32 -lcomdlg32 -lgdi32 -lwinmm -lkernel32
goto FIN

:concat
set OBJS=%~1 %OBJS%
EXIT /B

:usage
echo "Usage : %0 DIRECTORY_APPLI NAME_APPLI console|windows|lib|dll Debug|Release"
echo "et si pas de deuxième paramètre, affichage de cette explication d'usage"
echo "ou alors, le répertoire de l'application n'existe pas ... !"
 
:FIN
SET INCLUDE=%INCSAV%
SET LIB=%LIBSAV%
SET PATH=%PATHSAV%
cd %DIRINIT%
