@echo off
SET THEFILE=c:\users\alexis\docume~1\facult~1\2doao~1\fod\ejerci~1\ejerci~1\practi~1\ej4pr1.exe
echo Linking %THEFILE%
c:\dev-pas\bin\ldw.exe  -s   -b base.$$$ -o c:\users\alexis\docume~1\facult~1\2doao~1\fod\ejerci~1\ejerci~1\practi~1\ej4pr1.exe link.res
if errorlevel 1 goto linkend
goto end
:asmend
echo An error occured while assembling %THEFILE%
goto end
:linkend
echo An error occured while linking %THEFILE%
:end
