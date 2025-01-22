@echo off

IF "%2"=="" (set WPDPACKDESTDIR=.\npcap-sdk\) ELSE (set WPDPACKDESTDIR=%2)

IF ""=="%1" (set WINPCAPSOURCEDIR=.\) ELSE (set WINPCAPSOURCEDIR=%1) 

echo Creating \Include folder
mkdir %WPDPACKDESTDIR%  		2>nul >nul
mkdir %WPDPACKDESTDIR%\Include  	2>nul >nul
mkdir %WPDPACKDESTDIR%\Include\pcap  	2>nul >nul


SETLOCAL ENABLEEXTENSIONS
for /F "usebackq tokens=*" %%m in (`where.exe make`) do set MAKE=%%m
if not exist "%MAKE%" set MAKE=C:\cygwin\bin\make.exe
if not exist "%MAKE%" set MAKE=C:\msys64\usr\bin\make.exe
if not exist "%MAKE%" (
	echo "No make found"
	exit 1
)
for /F "usebackq tokens=2* delims==" %%i in (`%MAKE% -p -q -f Makefile.in -C "%WINPCAPSOURCEDIR%\wpcap\libpcap" ^| findstr /b "PUBHDR"`) do set PUBHDR=%%i

for %%i in (%PUBHDR:/=\%) do copy /v /Y "%WINPCAPSOURCEDIR%\wpcap\libpcap\%%i" "%WPDPACKDESTDIR%\Include\%%i"


xcopy /v /Y %WINPCAPSOURCEDIR%\Common\Packet32.h   %WPDPACKDESTDIR%\Include\ >nul
xcopy /v /Y %WINPCAPSOURCEDIR%\Common\npcap-bpf.h  %WPDPACKDESTDIR%\Include\ >nul
xcopy /v /Y %WINPCAPSOURCEDIR%\Common\npcap-defs.h %WPDPACKDESTDIR%\Include\ >nul

echo Folder \Include created successfully
set WPDPACKDESTDIR=
set WINPCAPSOURCEDIR=
