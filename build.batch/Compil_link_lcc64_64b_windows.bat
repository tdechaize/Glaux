@echo off
REM ---------------------------------------------------------------------------------------------------
REM
REM		 Compil_link_lcc64_64b_windows.bat : 	Nom de ce batch  
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
REM 	Détails des modifications : 	le paramétrage permet une certaine généricité, mais le structure des sources est imposée sur le sous-répertoire \src : %NAME_APPLI%.c + %NAME_APPLI%.rc + *.c
REM 	Version de ce script :			1.1.3  ->  "Version majeure" . "Version mineure" . "niveau de patch"
REM
REM ---------------------------------------------------------------------------------------------------
REM set lcc64=C:\lcc64
  
if [%1]==[] goto usage
if [%2]==[] goto usage
if not exist %1\ goto usage
@echo on
echo "Répertoire principal de l'application : %1"
echo "Nom de l'application  				: %2"

@echo off
set DIRINIT=%CD%
SET PATHSAV=%PATH%
SET LIBSAV=%LIB%
SET INCSAV=%INCLUDE%
set SOURCE_DIR=%1
set NAME_APPLI=%2
cd %SOURCE_DIR%

REM    Génération d'une application [console|windows|lib|dll] (compil + link/lcclib) pour le compilateur LCC 64 bits
:LCC64
SET PATH=C:\lcc64\bin;%PATH%
SET INCLUDE=C:\lcc64\include64
set LIB=C:\lcc64\lib64
SET OBJS=
if "%3"=="console" goto CONSOL
if "%3"=="windows" goto APPWIN
if "%3"=="lib" goto LIBRA
if "%3"=="dll" goto DLLA

:CONSOL
echo "LCC64 -> Genération console de l'application en mode : %4"
if "%4"=="Debug" goto DEBCONS
set "CFLAGS=-c -DNDEBUG"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         lcc %CFLAGS% -I%INCLUDE% -Foobjlcc64\Release\%%a.obj src\%%a.c
		 call :concat objlcc64\Release\%%a.obj
		 )
)
lcc64 %CFLAGS% -I%INCLUDE% -Foobjlcc64\Release\%NAME_APPLI%.obj src\%NAME_APPLI%.c
lrc -I%INCLUDE% -Foobjlcc64\Release\%NAME_APPLI%.res src\%NAME_APPLI%.rc
lcclnk64 -subsystem console -L"%LIB%" objlcc64\Release\%NAME_APPLI%.obj objlcc64\Release\%NAME_APPLI%.res -o binlcc64\Release\%NAME_APPLI%.exe opengl32.lib gdi32.lib advapi32.lib comdlg32.lib winmm.lib user32.lib kernel32.lib
goto FIN
:DEBCONS
set "CFLAGS=-c -g2 -DDEBUG -D_DEBUG"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         lcc %CFLAGS% -I%INCLUDE% -Foobjlcc64\Debug\%%a.obj src\%%a.c
		 call :concat objlcc64\Debug\%%a.obj
		 )
)
lcc64 %CFLAGS% -I%INCLUDE% -Foobjlcc64\Debug\%NAME_APPLI%.obj src\%NAME_APPLI%.c
lrc -I%INCLUDE% -Foobjlcc64\Debug\%NAME_APPLI%.res src\%NAME_APPLI%.rc
lcclnk64 -subsystem console -L"%LIB%" objlcc64\Debug\%NAME_APPLI%.obj objlcc64\Debug\%NAME_APPLI%.res -o binlcc64\Debug\%NAME_APPLI%.exe glu32.lib opengl32.lib gdi32.lib advapi32.lib comdlg32.lib winmm.lib user32.lib kernel32.lib
goto FIN

:APPWIN
echo "LCC64 -> Genération windows de l'application en mode : %4"
if "%4"=="Debug" goto DEBAPP
set "CFLAGS=-c -DNDEBUG"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         lcc %CFLAGS% -I%INCLUDE% -Foobjlcc64\Release\%%a.obj src\%%a.c
		 call :concat objlcc64\Release\%%a.obj
		 )
)
lcc64 %CFLAGS% -I%INCLUDE% -Foobjlcc64\Release\%NAME_APPLI%.obj src\%NAME_APPLI%.c
lrc -I%INCLUDE% -Foobjlcc64\Release\%NAME_APPLI%.res src\%NAME_APPLI%.rc
lcclnk64 -subsystem windows -L"%LIB%" objlcc64\Release\%NAME_APPLI%.obj objlcc64\Release\%NAME_APPLI%.res -o binlcc64\Release\%NAME_APPLI%.exe glu32.lib opengl32.lib gdi32.lib advapi32.lib comdlg32.lib winmm.lib user32.lib kernel32.lib
goto FIN
:DEBAPP
set "CFLAGS=-c -g2 -DDEBUG -D_DEBUG"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         lcc %CFLAGS% -I%INCLUDE% -Foobjlcc64\Debug\%%a.obj src\%%a.c
		 call :concat objlcc64\Debug\%%a.obj
		 )
)
lcc64 %CFLAGS% -I%INCLUDE% -Foobjlcc64\Debug\%NAME_APPLI%.obj src\%NAME_APPLI%.c
lrc -I%INCLUDE% -Foobjlcc64\Debug\%NAME_APPLI%.res src\%NAME_APPLI%.rc
lcclnk64 -subsystem windows -L"%LIB%" objlcc64\Debug\%NAME_APPLI%.obj objlcc64\Debug\%NAME_APPLI%.res -o binlcc64\Debug\%NAME_APPLI%.exe glu32.lib opengl32.lib gdi32.lib advapi32.lib comdlg32.lib winmm.lib user32.lib kernel32.lib
goto FIN

:LIBRA
echo "LCC64 -> Genération d'une librairie en mode : %4"
if "%4"=="Debug" goto DEBLIB
set "CFLAGS=-c -DNDEBUG"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         lcc %CFLAGS% -I%INCLUDE% -Foobjlcc64\Release\%%a.obj src\%%a.c
		 call :concat objlcc64\Release\%%a.obj
		 )
)
lcc64 %CFLAGS% -I%INCLUDE% -Foobjlcc64\Release\%NAME_APPLI%.obj src\%NAME_APPLI%.c
REM lrc -I%INCLUDE% -Foobjlcc64\Release\%NAME_APPLI%.res src\%NAME_APPLI%.rc
lcclib64 /out:binlcc64\Release\%NAME_APPLI%.lib objlcc64\Release\%NAME_APPLI%.obj
goto FIN
:DEBLIB
set "CFLAGS=-c -g2 -DDEBUG -D_DEBUG"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         lcc %CFLAGS% -I%INCLUDE% -Foobjlcc64\Debug\%%a.obj src\%%a.c
		 call :concat objlcc64\Debug\%%a.obj
		 )
)
lcc64 %CFLAGS% -I%INCLUDE% -Foobjlcc64\Debug\%NAME_APPLI%.obj src\%NAME_APPLI%.c
REM lrc -I%INCLUDE% -Foobjlcc64\Debug\%NAME_APPLI%.res src\%NAME_APPLI%.rc
lcclib64 /out:binlcc64\Debug\%NAME_APPLI%.lib objlcc64\Debug\%NAME_APPLI%.obj
goto FIN

:DLLA
echo "LCC64 -> Genération d'une librairie partagée (.ie. DLL) en mode : %4"
if "%4"=="Debug" goto DEBDLL
set "FLAGS=-c -DNDEBUG"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         lcc %CFLAGS% -I%INCLUDE% -Foobjlcc64\Release\%%a.obj src\%%a.c
		 call :concat objlcc64\Release\%%a.obj
		 )
)
lcc64 %CFLAGS% -I%INCLUDE% -Foobjlcc64\Release\%NAME_APPLI%.obj src\%NAME_APPLI%.c
lrc -I%INCLUDE% -Foobjlcc64\Release\%NAME_APPLI%.res src\%NAME_APPLI%.rc
lcclnk64 -dll -L"%LIB%" objlcc64\Release\%NAME_APPLI%.obj objlcc64\Release\%NAME_APPLI%.res -o binlcc64\Release\%NAME_APPLI%.dll opengl32.lib gdi32.lib advapi32.lib comdlg32.lib winmm.lib user32.lib kernel32.lib
lcclib64 /out:binlcc64\Release\%NAME_APPLI%.lib objlcc64\Release\%NAME_APPLI%.obj
goto FIN
:DEBDLL
set "FLAGS=-c -g2 -DDEBUG -D_DEBUG"
if exist %1\src_c.txt (
   for /f "tokens=* delims=" %%a in ('type %1\src_c.txt') do (
         lcc %CFLAGS% -I%INCLUDE% -Foobjlcc64\Debug\%%a.obj src\%%a.c
		 call :concat objlcc64\Debug\%%a.obj
		 )
)
lcc64 %CFLAGS% -I%INCLUDE% -Foobjlcc64\Debug\%NAME_APPLI%.obj src\%NAME_APPLI%.c
lrc -I%INCLUDE% -Foobjlcc64\Debug\%NAME_APPLI%.res src\%NAME_APPLI%.rc
lcclnk64 -dll -L"%LIB%" objlcc64\Debug\%NAME_APPLI%.obj objlcc64\Debug\%NAME_APPLI%.res -o binlcc64\Debug\%NAME_APPLI%.exe glu32.lib opengl32.lib gdi32.lib advapi32.lib comdlg32.lib winmm.lib user32.lib kernel32.lib
lcclib64 /out:binlcc64\Debug\%NAME_APPLI%.lib objlcc64\Debug\%NAME_APPLI%.obj
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
cd %DIRINIT%