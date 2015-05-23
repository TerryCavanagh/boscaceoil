
@echo off

if exist application.xml (
	ECHO The file application.xml exists!
	ECHO.
) else (
	ECHO The file application.xml doesn't exist. 
	ECHO.
	ECHO Please make sure this file is available and try again.
	ECHO.
	PAUSE
	goto end
)

::
:: Lets find the SWF's name inside application.xml for the file we want to create 
::
setlocal enableextensions enabledelayedexpansion
set xmlFile=application.xml
set fileName=
for /f "tokens=3 delims=<>" %%v in ('findstr /n /i /c:"<content>" "%xmlFile%"') do (
	if "%%v" == "" (
		goto defaultName
	)
	if "%%v" == " " (
		goto defaultName
	)
	set fileName=%%v
	goto checkFile
)

:defaultName
ECHO No file name found in appplication.xml. Using BoscaCeoil.swf...
ECHO.
set fileName=BoscaCeoil.swf

:checkFile
ECHO Searching for %fileName%...
ECHO.

if exist %fileName% (
	ECHO %fileName% exists!
	ECHO.
	goto fileExists
) else (
	ECHO %fileName% doesn't exist. Compiling the application...
	ECHO.
	goto createSwf
)

:createSwf
SET airVar=%AIR_SDK_HOME%
if "%airVar%"=="" (
	ECHO AIR_SDK_HOME enviroment variable doesn't exist. 
	ECHO.
	ECHO Please create it before running this bat.
	ECHO.
	PAUSE
	goto end
) else (
	CALL %AIR_SDK_HOME%\bin\amxmlc.bat -swf-version 20 -default-frame-rate 60 -default-size 768 480 -library-path+=lib/sion065.swc -source-path+=src -default-background-color 0x000000 -warnings -strict src/Main.as -o %fileName% -define+=CONFIG::desktop,true -define+=CONFIG::web,false
	ECHO.
	ECHO Compilation finished.
	ECHO.
	ECHO If no error was thrown by the Java Runtime, %fileName% should now exist.
	ECHO.
	goto checkFile
)

:fileExists
ECHO.
ECHO Running the application...
%AIR_SDK_HOME%\bin\adl application.xml

:end