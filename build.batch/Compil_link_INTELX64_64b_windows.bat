@echo off
REM ---------------------------------------------------------------------------------------------------
REM
REM		 Compil_link_INTELX64_64b_windows.bat : 	Nom de ce batch  
REM
REM      Batch de lancement d'une génération d'une application Windows (sources C avec un fichier resource) 
REM    avec le compilateur icx inclus dans le package OneAPI Intel C/C++ compiler adossé à Visual Studio 2022 Community.
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
REM     Date de création :				11 juin 2024   
REM 	Date dernière modification : 	11 juin 2024 -> Adjonction pour le compilateur OneAPI INTEL C/C++
REM 	Détails des modifications : 	Il faut adpater le PATH Windows ainsi que les variables d'environnement INC, INC#n et LIB
REM 	Version de ce script :			1.1.0  ->  "Version majeure" . "Version mineure" . "niveau de patch"
REM
REM ---------------------------------------------------------------------------------------------------
REM set KIT_WIN_NUM=10.0.26100.0
REM set KIT_WIN_VERSION=10
REM set VS_NUM=14.41.34120
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

REM    Génération d'une application [console|windows|lib|dll] (compil + link/ar) pour le compilateur  OneAPI INTEL C/C++ adosse a Visual Studio 2022
:INTELX64
SET PATH=C:\Program Files\Microsoft Visual Studio\%VS_VERSION%\Community\VC\Tools\MSVC\%VS_NUM%\bin\Hostx64\x64;C:\Program Files (x86)\Windows Kits\%KIT_WIN_VERSION%\bin\%KIT_WIN_NUM%\x64;%PATH%
SET PATH=C:\Program Files\Microsoft Visual Studio\%VS_VERSION%\Community\Msbuild\Current\Bin\Amd64;C:\Program Files (x86)\Intel\oneAPI\tbb\latest\env\..\bin\;C:\Program Files (x86)\Intel\oneAPI\ocloc\latest\bin;C:\Program Files (x86)\Intel\oneAPI\dev-utilities\latest\bin;C:\Program Files (x86)\Intel\oneAPI\debugger\latest\env\\..\opt\debugger\bin;C:\Program Files (x86)\Intel\oneAPI\compiler\latest\bin32;C:\Program Files (x86)\Intel\oneAPI\compiler\latest\lib\ocloc;C:\Program Files (x86)\Intel\oneAPI\compiler\latest\bin;%PATH%
set "INCLUDE=C:\Program Files (x86)\Intel\oneAPI\tbb\latest\env\..\include;C:\Program Files (x86)\Intel\oneAPI\ocloc\latest\include;C:\Program Files (x86)\Intel\oneAPI\dev-utilities\latest\include;C:\Program Files (x86)\Intel\oneAPI\compiler\latest\include;C:\Program Files (x86)\Windows Kits\%KIT_WIN_VERSION%\Include\%KIT_WIN_NUM%\um;C:\Program Files (x86)\Windows Kits\%KIT_WIN_VERSION%\Include\%KIT_WIN_NUM%\ucrt;C:\Program Files (x86)\Windows Kits\%KIT_WIN_VERSION%\Include\%KIT_WIN_NUM%\shared;C:\Program Files\Microsoft Visual Studio\%VS_VERSION%\Community\VC\Tools\MSVC\%VS_NUM%\include"
set "INC1=C:\Program Files (x86)\Windows Kits\%KIT_WIN_VERSION%\Include\%KIT_WIN_NUM%\um"
set "INC2=C:\Program Files (x86)\Windows Kits\%KIT_WIN_VERSION%\Include\%KIT_WIN_NUM%\ucrt"
set "INC3=C:\Program Files (x86)\Windows Kits\%KIT_WIN_VERSION%\Include\%KIT_WIN_NUM%\shared"
set "INC4=C:\Program Files\Microsoft Visual Studio\%VS_VERSION%\Community\VC\Tools\MSVC\%VS_NUM%\include"
set "LIB=C:\Program Files (x86)\Intel\oneAPI\tbb\latest\env\..\lib\;C:\Program Files (x86)\Intel\oneAPI\compiler\latest\lib\clang\18\lib\windows;C:\Program Files (x86)\Intel\oneAPI\compiler\latest\opt\compiler\lib;C:\Program Files (x86)\Intel\oneAPI\compiler\latest\lib;C:\Program Files\Microsoft Visual Studio\%VS_VERSION%\Community\VC\Tools\MSVC\%VS_NUM%\ATLMFC\lib\x64;C:\Program Files\Microsoft Visual Studio\%VS_VERSION%\Community\VC\Tools\MSVC\%VS_NUM%\lib\x64;C:\Program Files (x86)\Windows Kits\NETFXSDK\4.8\lib\um\x64;C:\Program Files (x86)\Windows Kits\%KIT_WIN_VERSION%\lib\%KIT_WIN_NUM%\ucrt\x64;C:\Program Files (x86)\Windows Kits\%KIT_WIN_VERSION%\lib\%KIT_WIN_NUM%\\um\x64"
SET OBJS=
if "%3"=="console" goto CONSOL
if "%3"=="windows" goto APPWIN
if "%3"=="lib" goto LIBRA
if "%3"=="dll" goto DLLA

:CONSOL
echo "OneAPI INTEL C/C++ 64 bits (VS2022) -> Genération console de l'application en mode : %4"
if "%4"=="Debug" goto DEBCONS
set "CFLAGS=/nologo /c  /D NDEBUG "
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         icx %CFLAGS%  /FoobjINTELX64\Release\%%a.obj  src\%%a.c
		 call :concat objINTELX64\Release\%%a.obj
		 )
)
icx %CFLAGS%  /FoobjINTELX64\Release\%NAME_APPLI%.obj  src\%NAME_APPLI%.c
rc /I"%INC1%" /I"%INC2%" /I"%INC3%" /I"%INC4%" /FoobjINTELX64\Release\%NAME_APPLI%.res src\%NAME_APPLI%.rc
xilink.exe /nologo /subsystem:console /MACHINE:X64 %OBJS% objINTELX64\Release\%NAME_APPLI%.obj objINTELX64\Release\%NAME_APPLI%.res /out:binINTELX64\Release\%NAME_APPLI%.exe glu32.lib opengl32.lib user32.lib advapi32.lib comdlg32.lib winmm.lib gdi32.lib shell32.lib kernel32.lib
goto FIN
:DEBCONS
set "CFLAGS=/nologo /c  /Z7 /D DEBUG /D _DEBUG"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         icx %CFLAGS% /FoobjINTELX64\Debug\%%a.obj  src\%%a.c
		 call :concat objINTELX64\Debug\%%a.obj
		 )
)
icx %CFLAGS% /FoobjINTELX64\Debug\%NAME_APPLI%.obj  src\%NAME_APPLI%.c
rc /I"%INC1%" /I"%INC2%" /I"%INC3%" /I"%INC4%" /FoobjINTELX64\Debug\%NAME_APPLI%.res src\%NAME_APPLI%.rc
xilink.exe /nologo /subsystem:console /debug /MACHINE:X64 %OBJS% objINTELX64\Debug\%NAME_APPLI%.obj objINTELX64\Debug\%NAME_APPLI%.res /out:binINTELX64\Debug\%NAME_APPLI%.exe glu32.lib opengl32.lib user32.lib advapi32.lib comdlg32.lib winmm.lib gdi32.lib shell32.lib kernel32.lib
goto FIN

:APPWIN
echo "OneAPI INTEL C/C++ 64 bits (VS2022) -> Genération windows de l'application en mode : %4"
if "%4"=="Debug" goto DEBAPP
set "CFLAGS=/nologo /c /D NDEBUG"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         icx %CFLAGS% /I"%INC1%" /I"%INC2%" /I"%INC3%" /I"%INC4%" /FoobjINTELX64\Release\%%a.obj  src\%%a.c
		 call :concat objINTELX64\Release\%%a.obj
		 )
)
icx %CFLAGS% /FoobjINTELX64\Release\%NAME_APPLI%.obj  src\%NAME_APPLI%.c
rc /I"%INC1%" /I"%INC2%" /I"%INC3%" /I"%INC4%" /FoobjINTELX64\Release\%NAME_APPLI%.res src\%NAME_APPLI%.rc
xilink.exe /nologo /subsystem:windows /MACHINE:X64 %OBJS% objINTELX64\Release\%NAME_APPLI%.obj objINTELX64\Release\%NAME_APPLI%.res /out:binINTELX64\Release\%NAME_APPLI%.exe glu32.lib opengl32.lib user32.lib advapi32.lib comdlg32.lib winmm.lib gdi32.lib shell32.lib kernel32.lib
goto FIN
:DEBAPP
set "CFLAGS=/nologo /c  /Z7 /D DEBUG /D _DEBUG"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         icx %CFLAGS% /FoobjINTELX64\Debug\%%a.obj /c  src\%%a.c
		 call :concat objINTELX64\Debug\%%a.obj
		 )
)
icx %CFLAGS% /FoobjINTELX64\Debug\%NAME_APPLI%.obj /c  src\%NAME_APPLI%.c
rc /I"%INC1%" /I"%INC2%" /I"%INC3%" /I"%INC4%" /FoobjINTELX64\Debug\%NAME_APPLI%.res src\%NAME_APPLI%.rc
xilink.exe /nologo /debug /subsystem:windows /MACHINE:X64 %OBJS% objINTELX64\Debug\%NAME_APPLI%.obj objINTELX64\Debug\%NAME_APPLI%.res /out:binINTELX64\Debug\%NAME_APPLI%.exe glu32.lib opengl32.lib user32.lib advapi32.lib comdlg32.lib winmm.lib gdi32.lib shell32.lib kernel32.lib
goto FIN

:LIBRA
echo "OneAPI INTEL C/C++ 64 bits (VS2022) -> Genération d'une librairie en mode : %4"
if "%4"=="Debug" goto DEBLIB
set "CFLAGS=/nologo /c  /D NDEBUG"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         icx %CFLAGS% /FoobjINTELX64\Release\%%a.obj /c  src\%%a.c
		 call :concat objINTELX64\Release\%%a.obj
		 )
)
icx %CFLAGS% /FoobjINTELX64\Release\%NAME_APPLI%.obj /c  src\%NAME_APPLI%.c
REM rc /I"%INC1%" /I"%INC2%" /I"%INC3%" /I"%INC4%" /FoobjINTELX64\Release\%NAME_APPLI%.res src\%NAME_APPLI%.rc
xilib /MACHINE:X64 /subsystem:windows /out:binINTELX64\Release\%NAME_APPLI%.lib %OBJS% objINTELX64\Release\%NAME_APPLI%.obj 
goto FIN
:DEBLIB
set "CFLAGS=/nologo /c  /Z7 /D DEBUG /D _DEBUG"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         icx %CFLAGS% /FoobjINTELX64\Debug\%%a.obj /c  src\%%a.c
		 call :concat objINTELX64\Debug\%%a.obj
		 )
)
icx %CFLAGS% /FoobjINTELX64\Debug\%NAME_APPLI%.obj /c  src\%NAME_APPLI%.c
REM rc /I"%INC1%" /I"%INC2%" /I"%INC3%" /I"%INC4%" /FoobjINTELX64\Debug\%NAME_APPLI%.res src\%NAME_APPLI%.rc
xilib /MACHINE:X64 /subsystem:windows /out:binINTELX64\Debug\%NAME_APPLI%.lib %OBJS% objINTELX64\Debug\%NAME_APPLI%.obj 
goto FIN

:DLLA
echo "OneAPI INTEL C/C++ 64 bits (VS2022) -> Genération d'une librairie partagée (.ie. DLL) en mode : %4"
if "%4"=="Debug" goto DEBDLL
set "CFLAGS=/nologo /c /D NDEBUG"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         icx %CFLAGS% /FoobjINTELX64\Release\%%a.obj /c  src\%%a.c
		 call :concat objINTELX64\Release\%%a.obj
		 )
)
icx %CFLAGS%  /FoobjINTELX64\Release\%NAME_APPLI%.obj /c  src\%NAME_APPLI%.c
rc /I"%INC1%" /I"%INC2%" /I"%INC3%" /I"%INC4%" /FoobjINTELX64\Release\%NAME_APPLI%.res src\%NAME_APPLI%.rc
xilink /DLL /MACHINE:X64 %OBJS% objINTELX64\Release\%NAME_APPLI%.obj objINTELX64\Release\%NAME_APPLI%.res /out:binINTELX64\Release\%NAME_APPLI%.dll /IMPLIB:binINTELX64\Release\%NAME_APPLI%.lib glu32.lib opengl32.lib user32.lib advapi32.lib comdlg32.lib winmm.lib gdi32.lib shell32.lib kernel32.lib
goto FIN
:DEBDLL
set "CFLAGS=/nologo /c /Z7 /D DEBUG /D _DEBUG"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         icx %CFLAGS% /I"%INC1%" /I"%INC2%" /I"%INC3%" /I"%INC4%" /FoobjINTELX64\Debug\%%a.obj /c  src\%%a.c
		 call :concat objINTELX64\Debug\%%a.obj
		 )
)
icx %CFLAGS% /FoobjINTELX64\Debug\%NAME_APPLI%.obj /c  src\%NAME_APPLI%.c
rc /I"%INC1%" /I"%INC2%" /I"%INC3%" /I"%INC4%" /FoobjINTELX64\Debug\%NAME_APPLI%.res src\%NAME_APPLI%.rc
xilink /DLL /debug /MACHINE:X64 %OBJS% objINTELX64\Debug\%NAME_APPLI%.obj objINTELX64\Debug\%NAME_APPLI%.res /out:binINTELX64\Debug\%NAME_APPLI%.dll /IMPLIB:binINTELX64\Debug\%NAME_APPLI%.lib glu32.lib opengl32.lib user32.lib advapi32.lib comdlg32.lib winmm.lib gdi32.lib shell32.lib kernel32.lib
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
