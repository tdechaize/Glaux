@echo off
REM ---------------------------------------------------------------------------------------------------
REM
REM		 Compil_link_CLANGX32_32b_windows.bat : 	Nom de ce batch  
REM
REM      Batch de lancement d'une génération d'une application Windows (source C avec un fichier resource) 
REM    avec le compilateur clang inclus dans le package Mingw64 lui même associé à l'IDE Code::Blocks.
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
REM 	Détails des modifications : 	le paramétrage permet une certaine généricité, mais la structure des sources est imposée sur le sous-répertoire \src : %NAME_APPLI%.c + %NAME_APPLI%.rc + *.c
REM 	Version de ce script :			1.1.3  ->  "Version majeure" . "Version mineure" . "niveau de patch"
REM
REM ---------------------------------------------------------------------------------------------------
REM set LLVM=C:\Program Files (x86)\LLVM

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

REM    Génération d'une application [console|windows|lib|dll] (compil + link/ar) pour le compilateur CLANG/LLVM 32 bits adossé à l'environnement VS2002 
:CLANGX32
SET PATH=C:\Program Files\Microsoft Visual Studio\%VS_VERSION%\Community\VC\Tools\MSVC\%VS_NUM%\bin\Hostx86\x86;C:\Program Files (x86)\Windows Kits\%KIT_WIN_VERSION%\bin\%KIT_WIN_NUM%\x86;%PATH%
SET PATH=%LLVM%\bin;C:\Program Files\Microsoft Visual Studio\%VS_VERSION%\Community\Msbuild\Current\Bin;%PATH%
set "INCLUDE=%LLVM%\lib\clang\%CLANG_VERSION%\include;C:\Program Files (x86)\Windows Kits\%KIT_WIN_VERSION%\Include\%KIT_WIN_NUM%\shared;C:\Program Files (x86)\Windows Kits\%KIT_WIN_VERSION%\Include\%KIT_WIN_NUM%\ucrt;C:\Program Files (x86)\Windows Kits\%KIT_WIN_VERSION%\Include\%KIT_WIN_NUM%\um;C:\Program Files\Microsoft Visual Studio\%VS_VERSION%\Community\VC\Tools\MSVC\%VS_NUM%\include"
set "LIB=%LLVM%\lib\clang\%CLANG_VERSION%\lib\windows;C:\Program Files (x86)\Windows Kits\%KIT_WIN_VERSION%\Lib\%KIT_WIN_NUM%\ucrt\x86;C:\Program Files (x86)\Windows Kits\%KIT_WIN_VERSION%\Lib\%KIT_WIN_NUM%\um\x86;C:\Program Files\Microsoft Visual Studio\%VS_VERSION%\Community\VC\Tools\MSVC\%VS_NUM%\lib\x86;C:\Program Files\Microsoft Visual Studio\%VS_VERSION%\Community\VC\Tools\MSVC\%VS_NUM%\lib\x86\store"
set "INC1=C:\Program Files (x86)\Windows Kits\%KIT_WIN_VERSION%\Include\%KIT_WIN_NUM%\shared"
set "INC2=C:\Program Files (x86)\Windows Kits\%KIT_WIN_VERSION%\Include\%KIT_WIN_NUM%\ucrt"
set "INC3=C:\Program Files (x86)\Windows Kits\%KIT_WIN_VERSION%\Include\%KIT_WIN_NUM%\um"
set "INC4=C:\Program Files\Microsoft Visual Studio\%VS_VERSION%\Community\VC\Tools\MSVC\%VS_NUM%\include"
SET OBJS=
if "%3"=="console" goto CONSOL
if "%3"=="windows" goto APPWIN
if "%3"=="lib" goto LIBRA
if "%3"=="dll" goto DLLA

:CONSOL
echo "CLANG (adosse a VS2022 32 bits) : Generation console de l'application en mode : %4"
if "%4"=="Debug" goto DEBCONS
set "CFLAGS=-O2 -m32 -fms-extensions -target i686-pc-windows-msvc -DNDEBUG"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         clang %CFLAGS% -o objCLANGX32\Release\%%a.obj -c src\%%a.c
		 call :concat objCLANGX32\Release\%%a.obj
		 )
)
clang %CFLAGS% -o objCLANGX32\Release\%NAME_APPLI%.obj -c src\%NAME_APPLI%.c
rc /nologo /i"%INC1%" /i"%INC2%" /i"%INC3%" /i"%INC4%" /i"%INC5%" /fo objCLANGX32\Release\%NAME_APPLI%.res src\%NAME_APPLI%.rc
clang -m32 -fms-extensions -target i686-pc-windows-msvc %OBJS% objCLANGX32\Release\%NAME_APPLI%.obj objCLANGX32\Release\%NAME_APPLI%.res -o binCLANGX32\Release\%NAME_APPLI%.exe -Wl,--subsystem,console -lglu32 -lopengl32 -ladvapi32 -lcomdlg32 -lgdi32 -lwinmm -luser32 -lkernel32
goto FIN
:DEBCONS
set "CFLAGS=-O0 -m32 -fms-extensions -target i686-pc-windows-msvc -g -gcodeview -DDEBUG -D_DEBUG"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         clang %CFLAGS% -o objCLANGX32\Debug\%%a.obj -c src\%%a.c
		 call :concat objCLANGX32\Debug\%%a.obj
		 )
)
clang %CFLAGS% -o objCLANGX32\Debug\%NAME_APPLI%.obj -c src\%NAME_APPLI%.c
rc /nologo /i"%INC1%" /i"%INC2%" /i"%INC3%" /i"%INC4%" /fo objCLANGX32\Debug\%NAME_APPLI%.res src\%NAME_APPLI%.rc
clang -m32 -fms-extensions -target i686-pc-windows-msvc %OBJS% objCLANGX32\Debug\%NAME_APPLI%.obj objCLANGX32\Debug\%NAME_APPLI%.res -o binCLANGX32\Debug\%NAME_APPLI%.exe -Wl,--subsystem,console -Wl,/debug,/pdb:%NAME_APPLI%.pdb -lglu32 -lopengl32 -ladvapi32 -lcomdlg32 -lgdi32 -lwinmm -luser32 -lkernel32
goto FIN

:APPWIN
echo "CLANG (adosse a VS2022 32 bits) : Generation windows de l'application en mode : %4"
if "%4"=="Debug" goto DEBAPP
del binCLANGX32\Release\*.pdb
set "CFLAGS=-O2 -m32 -fms-extensions -target i686-pc-windows-msvc -DNDEBUG"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         clang %CFLAGS% -o objCLANGX32\Release\%%a.obj -c src\%%a.c
		 call :concat objCLANGX32\Release\%%a.obj
		 )
)
clang %CFLAGS% -o objCLANGX32\Release\%NAME_APPLI%.obj -c src\%NAME_APPLI%.c
rc /nologo /i"%INC1%" /i"%INC2%" /i"%INC3%" /i"%INC4%"  /fo objCLANGX32\Release\%NAME_APPLI%.res src\%NAME_APPLI%.rc
clang -m32 -fms-extensions -target i686-pc-windows-msvc %OBJS% objCLANGX32\Release\%NAME_APPLI%.obj objCLANGX32\Release\%NAME_APPLI%.res -o binCLANGX32\Release\%NAME_APPLI%.exe -lglu32 -lopengl32 -ladvapi32 -lcomdlg32 -lgdi32 -lwinmm -luser32 -lkernel32
goto FIN

:DEBAPP
del binCLANGX32\Debug\*.pdb
set "CFLAGS=-O0 -m32 -fms-extensions -target i686-pc-windows-msvc -g -gcodeview -DDEBUG -D_DEBUG"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         clang %CFLAGS% -o objCLANGX32\Debug\%%a.obj -c src\%%a.c
		 call :concat objCLANGX32\Debug\%%a.obj
		 )
)
clang %CFLAGS% -o objCLANGX32\Debug\%NAME_APPLI%.obj -c src\%NAME_APPLI%.c
rc /nologo /i"%INC1%" /i"%INC2%" /i"%INC3%" /i"%INC4%" /fo objCLANGX32\Debug\%NAME_APPLI%.res src\%NAME_APPLI%.rc
clang -m32 -fms-extensions -target i686-pc-windows-msvc %OBJS% objCLANGX32\Debug\%NAME_APPLI%.obj objCLANGX32\Debug\%NAME_APPLI%.res -o binCLANGX32\Debug\%NAME_APPLI%.exe -Wl,/debug,/pdb:%NAME_APPLI%.pdb -lglu32 -lopengl32 -ladvapi32 -lcomdlg32 -lgdi32 -lwinmm -luser32 -lkernel32
goto FIN

:LIBRA
echo "CLANG (adosse à VS2022 32 bits) -> Generation d'une librairie en mode : %4"
if "%4"=="Debug" goto DEBLIB
set "CFLAGS=-O2 -m32 -fms-extensions -target i686-pc-windows-msvc -DNDEBUG"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         clang %CFLAGS% -o objCLANGX32\Release\%%a.obj -c src\%%a.c
		 call :concat objCLANGX32\Release\%%a.obj
		 )
)
clang %CFLAGS% -o objCLANGX32\Release\%NAME_APPLI%.obj -c src\%NAME_APPLI%.c
REM rc /nologo /i"%INC1%" /i"%INC2%" /i"%INC3%" /i"%INC4%" /fo objCLANGX32\Release\%NAME_APPLI%.res src\%NAME_APPLI%.rc
REM ar ru binCLANGX32\Release\lib%NAME_APPLI%.a objCLANGX32\Release\%NAME_APPLI%.obj
clang -m32 -fms-extensions -target i686-pc-windows-msvc -o binCLANGX32\Release\%NAME_APPLI%.lib %OBJS% objCLANGX32\Release\%NAME_APPLI%.obj -lglu32 -lopengl32 -ladvapi32 -lcomdlg32 -lgdi32 -lwinmm -luser32 -lkernel32
goto FIN
:DEBLIB
set "CFLAGS=-O0 -m32 -fms-extensions -target i686-pc-windows-msvc -g -gcodeview -DDEBUG -D_DEBUG"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         clang %CFLAGS% -o objCLANGX32\Debug\%%a.obj -c src\%%a.c
		 call :concat objCLANGX32\Debug\%%a.obj
		 )
)
clang %CFLAGS% -o objCLANGX32\Debug\%NAME_APPLI%.obj -c src\%NAME_APPLI%.c
REM rc /nologo /i"%INC1%" /i"%INC2%" /i"%INC3%" /i"%INC4%" /fo objCLANGX32\Debug\%NAME_APPLI%.res src\%NAME_APPLI%.rc
REM ar ru binCLANGX32\Debug\lib%NAME_APPLI%.a objCLANGX32\Debug\%NAME_APPLI%.obj
clang -m32 -fms-extensions -target i686-pc-windows-msvc -o binCLANGX32\Debug\%NAME_APPLI%.lib %OBJS% objCLANGX32\Debug\%NAME_APPLI%.obj -lglu32 -lopengl32 -ladvapi32 -lcomdlg32 -lgdi32 -lwinmm -luser32 -lkernel32
goto FIN

:DLLA
echo "CLANG (adosse à VS2022 32 bits) -> Generation d'une librairie partagee (.ie. DLL) en mode : %4"
if "%4"=="Debug" goto DEBDLL
set "CFLAGS=-O2 -m32 -fms-extensions -target i686-pc-windows-msvc -DNDEBUG"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         clang %CFLAGS% -o objCLANGX32\Release\%%a.obj -c src\%%a.c
		 call :concat objCLANGX32\Release\%%a.obj
		 )
)
clang %CFLAGS%  -o objCLANGX32\Release\%NAME_APPLI%.obj -c src\%NAME_APPLI%.c
rc /nologo /i"%INC1%" /i"%INC2%" /i"%INC3%" /i"%INC4%"  /fo objCLANGX32\Release\%NAME_APPLI%.res src\%NAME_APPLI%.rc
clang -m32 -fms-extensions -target i686-pc-windows-msvc -shared -Wl,--out-implib,binCLANGX32\Release\lib%NAME_APPLI%.a -W1,—export-all-symbols -Wl,—enable-auto-image-base -Wl,--subsystem,windows %OBJS% objCLANGX32\Release\%NAME_APPLI%.obj objCLANGX32\Release\%NAME_APPLI%.res -o binCLANGX32\Release\%NAME_APPLI%.dll -lglu32 -lopengl32 -ladvapi32 -lcomdlg32 -lgdi32 -lwinmm -luser32 -lkernel32
goto FIN
:DEBDLL
set "CFLAGS=-O0 -m32 -fms-extensions -target i686-pc-windows-msvc -g -gcodeview -DDEBUG -D_DEBUG"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         clang %CFLAGS% -o objCLANGX32\Debug\%%a.obj -c src\%%a.c
		 call :concat objCLANGX32\Debug\%%a.obj
		 )
)
clang %CFLAGS% -o objCLANGX32\Debug\%NAME_APPLI%.obj -c src\%NAME_APPLI%.c
rc /nologo /i"%INC1%" /i"%INC2%" /i"%INC3%" /i"%INC4%" /fo objCLANGX32\Debug\%NAME_APPLI%.res src\%NAME_APPLI%.rc
clang -m32 -fms-extensions -target i686-pc-windows-msvc -shared  -Wl,--out-implib,binCLANGX32\Debug\lib%NAME_APPLI%.a -W1,—export-all-symbols -Wl,—enable-auto-image-base -Wl,--subsystem,windows -Wl,/debug,/pdb:%NAME_APPLI%.pdb %OBJS% objCLANGX32\Debug\%NAME_APPLI%.obj objCLANGX32\Debug\%NAME_APPLI%.res -o binCLANGX32\Debug\%NAME_APPLI%.dll -lglu32 -lopengl32 -ladvapi32 -lcomdlg32 -lgdi32 -lwinmm -luser32 -lkernel32
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
SET "INC1="
SET "INC2="
SET "INC3="
SET "INC4="
cd %DIRINIT%
