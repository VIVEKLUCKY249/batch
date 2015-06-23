@echo off

REM =================================
set MyDate=
for /f "skip=1" %%x in ('wmic os get localdatetime') do if not defined MyDate set MyDate=%%x
set TODAY=%MyDate:~0,4%-%MyDate:~4,2%-%MyDate:~6,2%
set MONTH=%MyDate:~0,4%-%MyDate:~4,2%

REM =================================
set LOG1=%temp%\%~n0-%COMPUTERNAME%-%TODAY%.txt
set TXT1=%temp%\%~n0.txt
set LINE=%temp%\%~n0-line.txt

REM =================================

set _=%~dp0\..\taskschd\%~n0-%COMPUTERNAME%.bat
if exist %_% call %_%

REM =================================

pushd %~dp0\..

REM =================================

REM get date and time 
for /f "delims=" %%a in ('date/t') do @set mydate=%%a 
for /f "delims=" %%a in ('time/t') do @set mytime=%%a 
set var=%mydate%%mytime% 

REM =================================

call %~dp0\..\utility\gitconf.bat

REM =================================

git pull																												>>%LOG1% 2>>&1

git add . --all																									>>%LOG1% 2>>&1
git commit -a -m "Automated commit at %var% on %COMPUTERNAME%"	>>%LOG1% 2>>&1
git push																												>>%LOG1% 2>>&1


REM =================================

popd

REM =================================

rem pause

rem C:\Windows\System32\timeout.exe 10

REM =================================
set UPDATED=
findstr /C:"Already up-to-date." %LOG1% >> %LINE%
findstr /C:"nothing to commit, working directory clean" %LOG1% >> %LINE%
call :COUNTLINE %LINE%
echo cnt=%cnt%
pause
if %cnt% GTR 0 set UPDATED=1

REM =================================
if defined UPDATED (
echo sending e-mail
REM sendemail -s msa.hinet.net -f egreta.su@msa.hinet.net -t chsliu@gmail.com -u [LOG] %COMPUTERNAME% %~n0 -m %0 -a %LOG1% %TXT1%
)

del %LOG1% %TXT1% %LINE%

goto :EOF

REM =================================
REM call :COUNTLINE <linefile>
REM call :COUNTLINE temp.txt
REM =================================
:COUNTLINE
for /f %%a in ('type "%1"^|find "" /v /c') do set /a cnt=%%a

exit /b
