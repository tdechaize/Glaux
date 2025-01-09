@echo off
REM ---------------------------------------------------------------------------------------------------
REM
REM		 Compil_link_VS2022X32_32b_windows.bat : 	Nom de ce batch  
REM
REM      Batch de lancement d'une génération d'une application Windows (sources C avec un fichier resource) 
REM    avec le compilateur Visual C/C++ inclus dans le package Visual Studio 2022 Community.
REM
REM     Dans les grands principes, on modifie certaines variables d'environnement dont le PATH Windows, afin 
REM     de pouvoir lancer une compilation du source C, du fichier de resource et enfin de l'édition de lien
REM     final qui génère l'application attendue ou du gestionnaire de librairie.
REM     Ce batch prend quatre paramètres  :
REM 				le répertoire de l'application (le 1er paramètre) qui doit contenir un sous-répertoire \src 
REM 								contenant les sources de celle-ci.
REM 				le nom de l'application (qui doit être identique au nom du fichier principal source C (main ou winmain), 
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
REM set KIT_WIN_NUM=10.0.22621.0
REM set KIT_WIN_VERSION=10
REM set VS_NUM=14.33.31629
REM set VS_VERSION=2022


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

REM    Génération d'une application [console|windows|lib|dll] (compil + link/ar) pour le compilateur Visual C/C++ inclus dans VS2022 Community
:VS2022X32
SET PATH=C:\Program Files\Microsoft Visual Studio\%VS_VERSION%\Community\VC\Tools\MSVC\%VS_NUM%\bin\Hostx86\x86;C:\Program Files (x86)\Windows Kits\%KIT_WIN_VERSION%\bin\%KIT_WIN_NUM%\x86;%PATH%
SET PATH=C:\Program Files\Microsoft Visual Studio\%VS_VERSION%\Community\Msbuild\Current\Bin;%PATH%
set "INC1=C:\Program Files (x86)\Windows Kits\%KIT_WIN_VERSION%\Include\%KIT_WIN_NUM%\um"
set "INC2=C:\Program Files (x86)\Windows Kits\%KIT_WIN_VERSION%\Include\%KIT_WIN_NUM%\ucrt"
set "INC3=C:\Program Files (x86)\Windows Kits\%KIT_WIN_VERSION%\Include\%KIT_WIN_NUM%\shared"
set "INC4=C:\Program Files\Microsoft Visual Studio\%VS_VERSION%\Community\VC\Tools\MSVC\%VS_NUM%\include"
set "LIB1=C:\Program Files (x86)\Windows Kits\%KIT_WIN_VERSION%\Lib\%KIT_WIN_NUM%\ucrt\x86"
set "LIB2=C:\Program Files (x86)\Windows Kits\%KIT_WIN_VERSION%\Lib\%KIT_WIN_NUM%\um\x86"
set "LIB3=C:\Program Files\Microsoft Visual Studio\%VS_VERSION%\Community\VC\Tools\MSVC\%VS_NUM%\lib\x86"
set "LIB4=C:\Program Files\Microsoft Visual Studio\%VS_VERSION%\Community\VC\Tools\MSVC\%VS_NUM%\lib\x86\store"
SET OBJS=
if "%3"=="console" goto CONSOL
if "%3"=="windows" goto APPWIN
if "%3"=="lib" goto LIBRA
if "%3"=="dll" goto DLLA

:CONSOL
echo "Visual C/C++ 32 bits (VS2022) -> Genération console de l'application en mode : %4"
if "%4"=="Debug" goto DEBCONS
set "CFLAGS=/nologo /TC /DNDEBUG"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         cl %CFLAGS% /I"%INC1%" /I"%INC2%" /I"%INC3%" /I"%INC4%" /FoobjVS2022X32\Release\%%a.obj /c src\%%a.c
		 call :concat objVS2022X32\Release\%%a.obj
		 )
)
cl %CFLAGS% /I"%INC1%" /I"%INC2%" /I"%INC3%" /I"%INC4%" /FoobjVS2022X32\Release\%NAME_APPLI%.obj /c src\%NAME_APPLI%.c
rc /I"%INC1%" /I"%INC2%" /I"%INC3%" /I"%INC4%" /FoobjVS2022X32\Release\%NAME_APPLI%.res src\%NAME_APPLI%.rc
link.exe /nologo /subsystem:console /LIBPATH:"%LIB1%" /LIBPATH:"%LIB2%" /LIBPATH:"%LIB3%" /LIBPATH:"%LIB4%"  %OBJS% objVS2022X32\Release\%NAME_APPLI%.obj objVS2022X32\Release\%NAME_APPLI%.res /out:binVS2022X32\Release\%NAME_APPLI%.exe glu32.lib opengl32.lib user32.lib advapi32.lib comdlg32.lib winmm.lib gdi32.lib shell32.lib kernel32.lib
goto FIN
:DEBCONS
set "CFLAGS=/nologo /TC /Zi /DDEBUG /D_DEBUG"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         cl %CFLAGS% /I"%INC1%" /I"%INC2%" /I"%INC3%" /I"%INC4%" /FoobjVS2022X32\Debug\%%a.obj /c src\%%a.c
		 call :concat objVS2022X32\Debug\%%a.obj
		 )
)
cl %CFLAGS% /I"%INC1%" /I"%INC2%" /I"%INC3%" /I"%INC4%" /FoobjVS2022X32\Debug\%NAME_APPLI%.obj /c src\%NAME_APPLI%.c
rc /I"%INC1%" /I"%INC2%" /I"%INC3%" /I"%INC4%" /FoobjVS2022X32\Debug\%NAME_APPLI%.res src\%NAME_APPLI%.rc
link.exe /nologo /subsystem:console /debug /MACHINE:X86 /LIBPATH:"%LIB1%" /LIBPATH:"%LIB2%" /LIBPATH:"%LIB3%" /LIBPATH:"%LIB4%" %OBJS% objVS2022X32\Debug\%NAME_APPLI%.obj objVS2022X32\Debug\%NAME_APPLI%.res /out:binVS2022X32\Debug\%NAME_APPLI%.exe glu32.lib opengl32.lib user32.lib advapi32.lib comdlg32.lib winmm.lib gdi32.lib shell32.lib kernel32.lib
goto FIN

:APPWIN
echo "Visual C/C++ 32 bits (VS2022) -> Genération windows de l'application en mode : %4"
if "%4"=="Debug" goto DEBAPP
set "CFLAGS=/nologo /TC /DNDEBUG "
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         cl %CFLAGS% /I"%INC1%" /I"%INC2%" /I"%INC3%" /I"%INC4%" /FoobjVS2022X32\Release\%%a.obj /c src\%%a.c
		 call :concat objVS2022X32\Release\%%a.obj
		 )
)
cl %CFLAGS%/I"%INC1%" /I"%INC2%" /I"%INC3%" /I"%INC4%" /FoobjVS2022X32\Release\%NAME_APPLI%.obj /c src\%NAME_APPLI%.c
rc /I"%INC1%" /I"%INC2%" /I"%INC3%" /I"%INC4%" /FoobjVS2022X32\Release\%NAME_APPLI%.res src\%NAME_APPLI%.rc
link.exe /nologo /subsystem:windows /LIBPATH:"%LIB1%" /MACHINE:X86 /LIBPATH:"%LIB2%" /LIBPATH:"%LIB3%" /LIBPATH:"%LIB4%" %OBJS% objVS2022X32\Release\%NAME_APPLI%.obj objVS2022X32\Release\%NAME_APPLI%.res /out:binVS2022X32\Release\%NAME_APPLI%.exe glu32.lib opengl32.lib user32.lib advapi32.lib comdlg32.lib winmm.lib gdi32.lib shell32.lib kernel32.lib
goto FIN
:DEBAPP
set "CFLAGS=/nologo /TC /Zi /DDEBUG /D_DEBUG"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         cl %CFLAGS% /I"%INC1%" /I"%INC2%" /I"%INC3%" /I"%INC4%" /FoobjVS2022X32\Debug\%%a.obj /c src\%%a.c
		 call :concat objVS2022X32\Debug\%%a.obj
		 )
)
cl %CFLAGS% /I"%INC1%" /I"%INC2%" /I"%INC3%" /I"%INC4%" /FoobjVS2022X32\Debug\%NAME_APPLI%.obj /c src\%NAME_APPLI%.c
rc /I"%INC1%" /I"%INC2%" /I"%INC3%" /I"%INC4%" /FoobjVS2022X32\Debug\%NAME_APPLI%.res src\%NAME_APPLI%.rc
link.exe /nologo /debug /subsystem:windows /MACHINE:X86 /LIBPATH:"%LIB1%" /LIBPATH:"%LIB2%" /LIBPATH:"%LIB3%" /LIBPATH:"%LIB4%" %OBJS% objVS2022X32\Debug\%NAME_APPLI%.obj objVS2022X32\Debug\%NAME_APPLI%.res /out:binVS2022X32\Debug\%NAME_APPLI%.exe glu32.lib opengl32.lib user32.lib advapi32.lib comdlg32.lib winmm.lib gdi32.lib shell32.lib kernel32.lib
goto FIN

:LIBRA
echo "Visual C/C++ 32 bits (VS2022) -> Genération d'une librairie en mode : %4"
if "%4"=="Debug" goto DEBLIB
set "CFLAGS=/nologo /TC /DNDEBUG"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         cl %CFLAGS% /I"%INC1%" /I"%INC2%" /I"%INC3%" /I"%INC4%" /FoobjVS2022X32\Release\%%a.obj /c src\%%a.c
		 call :concat objVS2022X32\Release\%%a.obj
		 )
)
cl %CFLAGS% /I"%INC1%" /I"%INC2%" /I"%INC3%" /I"%INC4%" /FoobjVS2022X32\Release\%NAME_APPLI%.obj /c src\%NAME_APPLI%.c
REM rc /I"%INC1%" /I"%INC2%" /I"%INC3%" /I"%INC4%" /FoobjVS2022X32\Release\%NAME_APPLI%.res src\%NAME_APPLI%.rc
lib /MACHINE:X86 /subsystem:windows /out:binVS2022X32\Release\%NAME_APPLI%.lib %OBJS% objVS2022X32\Release\%NAME_APPLI%.obj 
goto FIN
:DEBLIB
set "CFLAGS=/nologo /TC /Zi /DDEBUG /D_DEBUG"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         cl %CFLAGS% /I"%INC1%" /I"%INC2%" /I"%INC3%" /I"%INC4%" /FoobjVS2022X32\Debug\%%a.obj /c src\%%a.c
		 call :concat objVS2022X32\Debug\%%a.obj
		 )
)
cl %CFLAGS% /I"%INC1%" /I"%INC2%" /I"%INC3%" /I"%INC4%" /FoobjVS2022X32\Debug\%NAME_APPLI%.obj /c src\%NAME_APPLI%.c
REM rc /I"%INC1%" /I"%INC2%" /I"%INC3%" /I"%INC4%" /FoobjVS2022X32\Debug\%NAME_APPLI%.res src\%NAME_APPLI%.rc
lib /MACHINE:X86 /subsystem:windows /out:binVS2022X32\Debug\%NAME_APPLI%.lib %OBJS% objVS2022X32\Debug\%NAME_APPLI%.obj 
goto FIN

:DLLA
echo "Visual C/C++ 32 bits (VS2022) -> Genération d'une librairie partagée (.ie. DLL) en mode : %4"
if "%4"=="Debug" goto DEBDLL
set "CFLAGS=/nologo /TC /DNDEBUG"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         cl %CFLAGS% /I"%INC1%" /I"%INC2%" /I"%INC3%" /I"%INC4%" /FoobjVS2022X32\Release\%%a.obj /c src\%%a.c
		 call :concat objVS2022X32\Release\%%a.obj
		 )
)
cl %CFLAGS% /I"%INC1%" /I"%INC2%" /I"%INC3%" /I"%INC4%" /FoobjVS2022X32\Release\%NAME_APPLI%.obj /c src\%NAME_APPLI%.c
rc /I"%INC1%" /I"%INC2%" /I"%INC3%" /I"%INC4%" /FoobjVS2022X32\Release\%NAME_APPLI%.res src\%NAME_APPLI%.rc
link /DLL /MACHINE:X86 /LIBPATH:"%LIB1%" /LIBPATH:"%LIB2%" /LIBPATH:"%LIB3%" /LIBPATH:"%LIB4%" %OBJS% objVS2022X32\Release\%NAME_APPLI%.obj objVS2022X32\Release\%NAME_APPLI%.res /out:binVS2022X32\Release\%NAME_APPLI%.dll /IMPLIB:binVS2022X32\Release\%NAME_APPLI%.lib glu32.lib opengl32.lib user32.lib advapi32.lib comdlg32.lib winmm.lib gdi32.lib shell32.lib kernel32.lib
goto FIN
:DEBDLL
set "CFLAGS=/nologo /TC /Zi /DDEBUG /D_DEBUG"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         cl %CFLAGS% /I"%INC1%" /I"%INC2%" /I"%INC3%" /I"%INC4%" /FoobjVS2022X32\Debug\%%a.obj /c src\%%a.c
		 call :concat objVS2022X32\Debug\%%a.obj
		 )
)
cl %CFLAGS% /I"%INC1%" /I"%INC2%" /I"%INC3%" /I"%INC4%" /FoobjVS2022X32\Debug\%NAME_APPLI%.obj /c src\%NAME_APPLI%.c
rc /I"%INC1%" /I"%INC2%" /I"%INC3%" /I"%INC4%" /FoobjVS2022X32\Debug\%NAME_APPLI%.res src\%NAME_APPLI%.rc
link /DLL /debug /MACHINE:X86 /LIBPATH:"%LIB1%" /LIBPATH:"%LIB2%" /LIBPATH:"%LIB3%" /LIBPATH:"%LIB4%" %OBJS% objVS2022X32\Debug\%NAME_APPLI%.obj objVS2022X32\Debug\%NAME_APPLI%.res /out:binVS2022X32\Debug\%NAME_APPLI%.dll /IMPLIB:binVS2022X32\Debug\%NAME_APPLI%.lib glu32.lib opengl32.lib user32.lib advapi32.lib comdlg32.lib winmm.lib gdi32.lib shell32.lib kernel32.lib
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
SET INC1=""
SET INC2=""
SET INC3=""
SET INC4=""
SET LIB1=""
SET LIB2=""
SET LIB3=""
SET LIB4=""
cd %DIRINIT%
