REM =================================

set path=%path%;%~dp0\..\utility

REM =================================
set MyDate=
for /f "skip=1" %%x in ('wmic os get localdatetime') do if not defined MyDate set MyDate=%%x
set TODAY=%MyDate:~0,4%-%MyDate:~4,2%-%MyDate:~6,2%
set MONTH=%MyDate:~0,4%-%MyDate:~4,2%
REM =================================

set LOG1=%temp%\%~n0-%COMPUTERNAME%-%TODAY%.txt
set TXT1=%temp%\%~n0.txt

REM =================================

echo. >>%LOG1%
echo. >>%TXT1%

REM =================================

call %~dp0\%~n0-%COMPUTERNAME%.bat > %LOG1%

REM =================================

rem copy %0 %TXT1%
copy %~dp0\%~n0-%COMPUTERNAME%.bat %TXT1%

sendemail -s msa.hinet.net -f egreta.su@msa.hinet.net -t chsliu@gmail.com -u [LOG] %COMPUTERNAME% %~n0 -m %0 -a %LOG1% %TXT1%

del %LOG1% %TXT1%