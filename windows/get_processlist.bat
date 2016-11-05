@echo off
echo Domain\User,Machine,ProcessName,ProcessID,WorkingSetSize
(for /f "skip=2 tokens=2 delims=, eol= " %%P in ('wmic process where "SessionId  != 0" get ProcessId /format:csv') do @call :AddOwner %%P) 2> nul
pause
goto :EOF

:AddOwner
SET Process=%1
(for /f "skip=5 tokens=1,2 delims==; " %%O in ('wmic process WHERE ProcessID^=%Process% Call GetOwner') do @call :BuildOwner %%O %%P) > nul
for /f "skip=1 tokens=* eol= " %%L in ('wmic process WHERE ProcessID^=%Process% GET Name^, ProcessID^, WorkingSetSize /format:csv') do @SET INFO=%%L
echo %DOMAIN%\%USER%,%INFO%
goto :EOF

    :BuildOwner
    SET PARAM=%1
    SET VALUE=%~2
    IF [%PARAM%]==[Domain] SET DOMAIN=%VALUE%
    IF [%PARAM%]==[User] SET USER=%VALUE%
    goto :EOF




wmic process where "SessionId  != 0" get ProcessId,Caption,SessionId,executablepath /format:csv