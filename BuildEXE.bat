@echo off
if %1. == . goto MissingParameter
if %1. == debug.   goto GoodParameter
if %1. == release. goto GoodParameter

echo You must send "debug" or "release" as parameter
goto End

:GoodParameter


rem SET HMGPATH=c:\Hmg

rem set PATH=C:\hmg\HARBOUR\bin;C:\hmg\MINGW\bin;%PATH%;c:\Hmg
rem set HB_COMPILER=mingw
rem set HB_PATH=C:\Hmg\Harbour
echo Compilando..




rem SET PATH=%HMGPATH%\harbour\bin;%HMGPATH%\mingw\bin;%PATH%


set PATH=C:\Harbour64\bin\win\mingw64;C:\MINGW64\bin;%PATH%;c:\Hmg
set HB_COMPILER=mingw64
set HB_PATH=C:\Harbour64


rem C:
rem cd\sisDbHmg\MigraCli
rem Cd %1

if %1 == debug (
	   echo Debug Compilacao.
		Build64 /n /b ImpBairros.Hbp ImpBairros.Hbc hbmySql.Hbc
			
		
		rem Ren b.exe ImpBairros.exe
) else (
	  echo Normal
	  	del b.exe
		Build64 /n  ImpBairros.Hbp ImpBairros.Hbc hbmySql.Hbc
		

)


goto End
:MissingParameter
echo Missing Parameter
:End
