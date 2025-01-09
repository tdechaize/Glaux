@echo off
REM ---------------------------------------------------------------------------------------------------
REM
REM		 Compil_only_dmc_32b_windows.bat : 	Nom de ce batch  
REM
REM      Batch de lancement d'une générations d'une application Windows (sources C avec un fichier resource) 
REM    avec le compilateur Digital Mars Compiler v857.
REM
REM     Dans les grands principes, on modifie certaines variables d'environnement dont le PATH Windows, afin 
REM     de pouvoir lancer une compilation du source C, du fichier de resource et enfin de l'édition de lien
REM     final qui génère l'application attendue.
REM     Ce batch prend quatre paramètres  :
REM 				le nom du source à compiler,
REM					La cible de generation : 									  console|windows|lib|dll
REM					la catégorie de génération attendue parmi la liste suivante : Debug|Release
REM
REM 	PS : la procédure "create_dir.bat" permet de créer TOUS les répertoires utiles à ces générations multiples 
REM 					(certains compilateurs ne sont pas capables de les créer ONLINE s'ils sont absents !!)
REM 
REM 	AUTHOR : 						Thierry DECHAIZE
REM     Date de création :				26 Septembre 2022   
REM 	Date dernière modification : 	27 février 2023 -> une seule et unique compilation d'un fichier source
REM 	Détails des modifications : 	Ce paramétrage permet une certaine généricité, mais la structure des sources est imposée sur le sous-répertoire \src :
REM 									    %NAME_APPLI%.c + %NAME_APPLI%.rc + *.c
REM 	Version de ce script :			1.1.3  ->  "Version majeure" . "Version mineure" . "niveau de patch"
REM
REM ---------------------------------------------------------------------------------------------------
REM set dmc=C:\dmc
  
if [%1]==[] goto usage
if [%2]==[] goto usage
if [%3]==[] goto usage
echo "Nom du source a compiler 	: %1"
echo "Cible de generation 		: %2"
echo "Mode de generation 		: %3"

set DIRINIT=%CD%
SET PATHSAV=%PATH%
set NAMESOURCE=%1

REM    Génération d'une application [console|windows|lib|dll] (compil + link/lib) pour le compilateur Digital Mars Compiler 
:DMC
SET PATH=C:\dm\bin;%PATH%
if "%2"=="console" goto CONSOL
if "%2"=="windows" goto APPWIN
if "%2"=="lib" goto LIBRA
if "%2"=="dll" goto DLLA

:CONSOL
echo "Digital Mars Compiler C/C++ v8.57 -> Generation console de l'application en mode : %3"
if "%3"=="Debug" goto DEBCONS
dmc -c -mn -DNDEBUG -oobjDMC\Release\%1.obj src\%1.c 
goto FIN
:DEBCONS
dmc -c -mn -g -DDEBUG -D_DEBUG -oobjDMC\Debug\%1.obj src\%1.c 
goto FIN

:APPWIN
echo "Digital Mars Compiler C/C++ v8.57 -> Generation windows de l'application en mode : %3"
if "%3"=="Debug" goto DEBAPP
dmc src\%1.c -c -mn -DNDEBUG -oobjDMC\Release\%1.obj  
echo "Compilation reussie"
goto FIN
:DEBAPP
dmc src\%1.c -c -mn -g -DDEBUG -D_DEBUG -oobjDMC\Debug\%1.obj
echo "Compilation reussie"
goto FIN

:LIBRA
echo "Digital Mars Compiler C/C++ v8.57 -> Generation d'une librairie en mode : %3"
if "%3"=="Debug" goto DEBLIB
set "CFLAGS=-c -mn -DNDEBUG"
dmc src\%1.c -c -mn -DNDEBUG -oobjDMC\Release\%1.obj 
goto FIN
:DEBLIB
set "CFLAGS=-c -mn -g -DDEBUG -D_DEBUG"
dmc src\%1.c  -c -mn -g -DDEBUG -D_DEBUG -oobjDMC\Debug\%1.obj
goto FIN

:DLLA
echo "Digital Mars Compiler C/C++ v8.57 -> Generation d'une librairie partagée (.ie. DLL) en mode : %3"
if "%3"=="Debug" goto DEBDLL
set "CFLAGS=-c -mn -WD -DNDEBUG"
dmc src\%1.c  -c -mn -WD -DNDEBUG -oobjDMC\Release\%1.obj
goto FIN
:DEBDLL
set "CFLAGS=-c -mn -WD -g -DDEBUG -D_DEBUG"
dmc src\%1.c -c -mn -WD -g -DDEBUG -D_DEBUG -oobjDMC\Debug\%1.obj 
goto FIN

:concat
set "OBJS=%~1 %OBJS%"
EXIT /B

:usage
echo "Usage : %0 NAME_SOURCE console|windows|lib|dll Debug|Release"
echo "et si pas de deuxiee ou troisiee paramere, affichage de cette explication d'usage"

:FIN
SET PATH=%PATHSAV%
