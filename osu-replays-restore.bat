:: sub2pew // july 04, 2023

@echo off
title [sub2pew] osu-replays-restore

setlocal disableDelayedExpansion

set "stateDIR=%~dp0"
rem set "stateDIR=%stateDIR:~0,-1%"

setlocal enableDelayedExpansion

set /a osrQNT=0
set /a movQNT=0
set /a osrTOT=0

set osrCHK=0

set "stmST=[37m[ [35m%time%[37m ]"
set "inST=^<[94mINFO[37m^>"
set "prST=<[94mPROP[0m>"
set "wnST=^<[33mWARN[37m^>"
set "erST=^<[31mERRR[37m^>"

set "drMSG=Initial directory:"
set "goMSG=Processing replays..."
set "okMSG=Completed processing replays."
set "erMSG=Invalid input, please try again."

set "ccMSG=Changed working directory to:"

set "stMSG=Total replays processed:"
set "mvMSG=Total replays moved:"

set "mnNM=[sub2pew] osu-replays-restore"
set "ccNM=[sub2pew] counting..."
set "goNM=[sub2pew] restoring..."
set "okNM=[sub2pew] completed"

for /F "tokens=1-4 delims=:.," %%a in ("%time%") do (
    set "startTime=%%a^:%%b^:%%c^.%%d"
)

goto :check00

:: safe-zone, use for functions -- global
:fsCHK
for %%I in (".") do (
    if exist "%%~I\*.osr" (
        set "osrCHK=1"
    )   else (
        set "osrCHK=0"
    )
)
goto :eof

:tOUT1
timeout /t 1 /nobreak > NUL
goto :eof

:tOUT3
timeout /t 3 /nobreak > NUL
goto :eof
:: end of safe-zone

:: fileCHECK -- global
:check00
call :fsCHK

cls && @echo.

:check01
if %osrCHK%==1 (
    if exist "Data/r" (
        if exist "Replays" (
            call :tOUT1
            @echo   [37m[ [35m%time%[37m ] %wnST%[96m Replay file^(s^) found in your osu^^! root directory.[0m
            call :tOUT3
            @echo   [37m[ [35m%time%[37m ] %inST%[96m Your replays will be moved to 'Replays' folder.[0m
            call :tOUT3

            @echo.
            mkdir "Replays\[#] replayFiles" > NUL 2>&1
            for %%I in ("*.osr") do (
                set /A movQNT+=1
            )
            for %%I in (".osr") do (
                move /Y "*.osr" "Replays\[#] replayFiles" > NUL
            )
            
            @echo   [37m[ [35m%time%[37m ] %inST%[92m %mvMSG% !movQNT!.[0m && @echo.
            timeout /t 5 /nobreak > NUL
            
            goto :check02
        )
    )
)

:check02
call :fsCHK

if %osrCHK%==1 (
    goto :workPRMT
) else (
    if exist "[#] replayFiles" (
        goto :workPRMT
    ) else (
        if exist "Data/r" (
            goto :mainTSK1
        ) else (
            if exist "Replays" (
                goto :mainTSK1
            ) else (
                if defined 1OSU_ROOT (
                    call :tOUT1
                    @echo   [37m[ [35m%time%[37m ] %wnST%[96m Detected osu^^! installation.[0m
                    call :tOUT3
                    
                    cd /D "!OSU_ROOT!"

                    setlocal disableDelayedExpansion
                    set "stateDIR=%~dp0"
                    rem set "stateDIR=%stateDIR:~0,-1%"
                    setlocal enableDelayedExpansion

                    goto :mainTSK1
                ) else (
                    if defined 1UNNOTICED_FORCE_DEFAULT_PARSING (
                        call :tOUT1
                        @echo   [37m[ [35m%time%[37m ] %wnST%[96m Detected osu^^! installation.[0m
                        call :tOUT3
                        
                        cd /D "!UNNOTICED_FORCE_DEFAULT_PARSING!"
                        
                        setlocal disableDelayedExpansion
                        set "stateDIR=%~dp0"
                        rem set "stateDIR=%stateDIR:~0,-1%"
                        setlocal enableDelayedExpansion

                        goto :mainTSK1
                    ) else (
                        goto :warnEXIT
                    )
                )
            )
        )
    )
)

:: safe-zone, use for functions -- global
:calcDAT
for %%I in ("Data/r/*.osr") do (
    set /A osrTOT+=1
    title %ccNM% [!osrTOT!x]
)
goto :eof

:calcREP
for %%I in ("Replays/*.osr") do (
    set /A osrTOT+=1
    title %ccNM% [!osrTOT!x]
)
goto :eof

:calcMOV
for %%I in ("Replays/[#] replayFiles/*.osr") do (
    set /A osrTOT+=1
    title %ccNM% [!osrTOT!x]
)
goto :eof

:calcSHG
for %%I in ("Replays/cookiezi-replays") do (
    set /A osrTOT+=1
    title %ccNM% [!osrTOT!x]
)
goto :eof
:calcDIR

for %%I in ("[#] replayFiles/*.osr") do (
    set /A osrTOT+=1
    title %ccNM% [!osrTOT!x]
)
goto :eof

:doDAT
call :calcDAT
for %%I in ("Data/r/*.osr") do (
    setlocal disableDelayedExpansion
    set "fname=%%~nI"
    "Data/r/%%I"
    endlocal
    set /A osrQNT+=1
    setlocal enableDelayedExpansion
    title %goNM% [!osrQNT!x / !osrTOT!x]
    endlocal
)
goto :eof

:doREP
call :calcREP
for %%I in ("Replays/*.osr") do (
    setlocal disableDelayedExpansion
    set "fname=%%~nI"
    "Replays/%%I"
    endlocal
    set /A osrQNT+=1
    setlocal enableDelayedExpansion
    title %goNM% [!osrQNT!x / !osrTOT!x]
    endlocal
)
goto :eof

:doMOV
call :calcMOV
for %%I in ("Replays/[#] replayFiles/*.osr") do (
    setlocal disableDelayedExpansion
    set "fname=%%~nI"
    "Replays/[#] replayFiles/%%I"
    endlocal
    set /A osrQNT+=1
    setlocal enableDelayedExpansion
    title %goNM% [!osrQNT!x / !osrTOT!x]
    endlocal
)
goto :eof

:doSHG
call :calcSHG
for /R "Replays/cookiezi-replays" %%I in (*.osr) do (
    setlocal disableDelayedExpansion
    set "fname=%%~nI"
    "Replays/cookiezi-replays/%%I"
    endlocal
    set /A osrQNT+=1
    setlocal enableDelayedExpansion
    title %goNM% [!osrQNT!x / !osrTOT!x]
    endlocal
)

:doDIR
call :calcDIR
for %%I in ("[#] replayFiles/*.osr") do (
    setlocal disableDelayedExpansion
    set "fname=%%~nI"
    "[#] replayFiles/%%I"
    endlocal
    set /A osrQNT+=1
    setlocal enableDelayedExpansion
    title %goNM% [!osrQNT!x / !osrTOT!x]
    endlocal
)
goto :eof
:: end of safe-zone

:mainTSK1
cls && @echo.
@echo   [37m[ [35m%time%[37m ] %inST%[96m %drMSG% '!stateDIR!'[0m
@echo   [37m[ [35m%time%[37m ] %wnST%[96m osu^^! game folders found in current directory.[0m
@echo. && set /P "mASK1=  [37m[ [35m%time%[37m ] %prST%[93m Do you want to scan 'Data' and 'Replays' folder? [Y/N][0m >> "

if /I "%mASK1%" EQU "Y" goto :osugDIR1
if /I "%mASK1%" EQU "y" goto :osugDIR1

if /I "%mASK1%" EQU "N" goto :chkTSK2
if /I "%mASK1%" EQU "n" goto :chkTSK2

if /I "%mASK1%" EQU "" goto :mainTSK1

@echo   [37m[ [35m%time%[37m ] %erST%[93m %erMSG%[0m
call :tOUT3

:chkTSK2
if exist "_aprilFools2015" (
    if exist "_aprilFools2016" (
        if exist "_aprilFools2018" (
            if exist "_aprilFools2019" (
                if exist "_osu2007b99" (
                    if exist "_osu2012spoilerEaster" (
                        if exist "_osu2012benchmarkShine" (
                            if exist "_osu20190410" (
                                if exist "_osuripple" (
                                    if exist "_osufx" (
                                        goto :mainTSK2
                                    ) else (
                                        goto :mainCOMP
                                    )
                                ) else (
                                    goto :mainCOMP
                                )
                            ) else (
                                goto :mainCOMP
                            )
                        ) else (
                            goto :mainCOMP
                        )
                    ) else (
                        goto :mainCOMP
                    )
                ) else (
                    goto :mainCOMP
                )
            ) else (
                goto :mainCOMP
            )
        ) else (
            goto :mainCOMP
        )
    ) else (
        goto :mainCOMP
    )
) else (
    goto :mainCOMP
)

:mainTSK2
set /P "mASK2=  [37m[ [35m%time%[37m ] %prST%[93m Do you want to scan other folders? [Y/N][0m >> "

if /I "%mASK2%" EQU "Y" cls && goto :2015d
if /I "%mASK2%" EQU "y" cls && goto :2015d

if /I "%mASK2%" EQU "N" goto :mainCOMP
if /I "%mASK2%" EQU "n" goto :mainCOMP

if /I "%mASK2%" EQU "" goto :mainTSK2

@echo   [37m[ [35m%time%[37m ] %erST%[93m %erMSG%[0m
call :tOUT3
goto :mainTSK1


:: doFILE -- global
:workPRMT
cls && @echo.
@echo   [37m[ [35m%time%[37m ] %inST%[96m %drMSG% '!stateDIR!'[0m
@echo   [37m[ [35m%time%[37m ] %wnST%[96m Replay^(s^) or folder^(s^) found in current directory.[0m
@echo. && set /P "wASK1=  [37m[ [35m%time%[37m ] %prST%[93m Do you want to start now? [Y/N][0m >> "

if /I "%wASK1%" EQU "Y" goto :workDIR
if /I "%wASK1%" EQU "y" goto :workDIR

if /I "%wASK1%" EQU "N" goto :mainCOMP
if /I "%wASK1%" EQU "n" goto :mainCOMP

if /I "%wASK1%" EQU "" goto :workPRMT

@echo   [37m[ [35m%time%[37m ] %erST%[93m %erMSG%[0m
call :tOUT3
goto :workPRMT

:workDIR
cls && @echo.

call :tOUT3
@echo   [37m[ [35m%time%[37m ] %inST%[96m %goMSG%[0m
title %goNM%

mkdir "[#] replayFiles" > NUL 2>&1
for %%I in ("*.osr") do (
    set /A movQNT+=1
)
for %%I in ("*.osr") do (
    move /Y "*.osr" "[#] replayFiles" > NUL
)
:: how to fix this madness lol (fixed)
call :doDIR

call :tOUT1
@echo   [37m[ [35m%time%[37m ] %inST%[92m %okMSG%[0m
title %okNM%
goto :mainCOMP

:: alertWARN -- global
:warnEXIT
call :tOUT1
@echo   [37m[ [35m%time%[37m ] %wnST%[96m No replay files have been found.[0m
call :tOUT3
@echo   [37m[ [35m%time%[37m ] %wnST%[96m Neither any game folders have been found[0m
call :tOUT3
@echo   [37m[ [35m%time%[37m ] %wnST%[96m Make sure to run this script from your osu^^! root directory.[0m
goto :mainCOMP


:: alertDATA -- folder osu!
:osugDIR1
cls && @echo.

call :tOUT3
@echo   [37m[ [35m%time%[37m ] %inST%[96m %goMSG% 'osu^^!\Data\r'[0m
title %goNM%

:: doDATA -- folder osu!
call :doDAT
call :tOUT1
@echo   [37m[ [35m%time%[37m ] %inST%[92m %okMSG%[0m
title %okNM%

:: alertREPLAY -- folder osu!
@echo.
call :tOUT3
@echo   [37m[ [35m%time%[37m ] %inST%[96m %goMSG% 'osu^^!\Replays'[0m
title %goNM%

:: doREPLAY -- folder osu!
call :doREP
if exist "Replays\[#] replayFiles" (
    call :doMOV
)   else (
    goto :movSKP
)
:movSKP
call :tOUT1
@echo   [37m[ [35m%time%[37m ] %inST%[92m %okMSG%[0m
title %okNM%

if exist "Replays\cookiezi-replays" (
    goto :shigeDIR
)   else (
    goto :shigeSKP
)

:: alertREPLAYcookiezi01 -- folder osu!
:shigeDIR
@echo.
call :tOUT3
@echo   [37m[ [35m%time%[37m ] %inST%[96m %goMSG% 'osu^^!\Replays\cookiezi-replays'[0m
title %goNM%

:: doREPLAYcookiezi01 -- folder osu!
:doSHG
call :tOUT1
@echo   [37m[ [35m%time%[37m ] %inST%[92m %okMSG%[0m
title %okNM%


:shigeSKP

if exist "_aprilFools2015" (
    goto :2015d
)   else (
    goto :2015ds
)

:: alertDATA -- folder _aprilFools2015
:2015d
cd "_aprilFools2015"
@echo.

call :tOUT3
@echo   [37m[ [35m%time%[37m ] ^<[36mSTAT[37m^>[93m %ccMSG% 'osu^^!\_aprilFools2015'[0m
call :tOUT1
@echo   [37m[ [35m%time%[37m ] %inST%[96m %goMSG% '...\Data\r'[0m
title %goNM%

:: doDATA -- _aprilFools2015
call :doDAT
call :tOUT1
@echo   [37m[ [35m%time%[37m ] %inST%[92m %okMSG%[0m
title %okNM%

:: alertREPLAY -- _aprilFools2015
@echo.
call :tOUT3
@echo   [37m[ [35m%time%[37m ] %inST%[96m %goMSG% '...\Replays'[0m
title %goNM%

:: doREPLAY -- _aprilFools2015
call :doREP
call :tOUT1
@echo   [37m[ [35m%time%[37m ] %inST%[92m %okMSG%[0m
title %okNM%
cd..


:2015ds

if exist "_aprilFools2016" (
    goto :2016d
)   else (
    goto :2016ds
)

:: alertDATA -- folder _aprilFools2016
:2016d
cd "_aprilFools2016"
@echo.

call :tOUT3
@echo   [37m[ [35m%time%[37m ] ^<[36mSTAT[37m^>[93m %ccMSG% 'osu^^!\_aprilFools2016'[0m
call :tOUT1
@echo   [37m[ [35m%time%[37m ] %inST%[96m %goMSG% '...\Data\r'[0m
title %goNM%

:: doDATA -- _aprilFools2016
call :doDAT
call :tOUT1
@echo   [37m[ [35m%time%[37m ] %inST%[92m %okMSG%[0m
title %okNM%

:: alertREPLAY -- _aprilFools2016
@echo.
call :tOUT3
@echo   [37m[ [35m%time%[37m ] %inST%[96m %goMSG% '...\Replays'[0m
title %goNM%

:: doREPLAY -- _aprilFools2016
call :doREP
call :tOUT1
@echo   [37m[ [35m%time%[37m ] %inST%[92m %okMSG%[0m
title %okNM%
cd..


:2016ds

if exist "_aprilFools2018" (
    goto :2018d
)   else (
    goto :2018ds
)

:: alertDATA -- folder _aprilFools2018
:2018d
cd "_aprilFools2018"
@echo.

call :tOUT3
@echo   [37m[ [35m%time%[37m ] ^<[36mSTAT[37m^>[93m %ccMSG% 'osu^^!\_aprilFools2018'[0m
call :tOUT1
@echo   [37m[ [35m%time%[37m ] %inST%[96m %goMSG% '...\Data\r'[0m
title %goNM%

:: doDATA -- _aprilFools2018
call :doDAT
call :tOUT1
@echo   [37m[ [35m%time%[37m ] %inST%[92m %okMSG%[0m
title %okNM%

:: alertREPLAY -- _aprilFools2018
@echo.
call :tOUT3
@echo   [37m[ [35m%time%[37m ] %inST%[96m %goMSG% '...\Replays'[0m
title %goNM%

:: doREPLAY -- _aprilFools2018
call :doREP
call :tOUT1
@echo   [37m[ [35m%time%[37m ] %inST%[92m %okMSG%[0m
title %okNM%
cd..


:2018ds

if exist "_aprilFools2019" (
    goto :2019d
)   else (
    goto :2019ds
)

:: alertDATA -- folder _aprilFools2019
:2019d
cd "_aprilFools2019"
@echo.

call :tOUT3
@echo   [37m[ [35m%time%[37m ] ^<[36mSTAT[37m^>[93m %ccMSG% 'osu^^!\_aprilFools2019'[0m
call :tOUT1
@echo   [37m[ [35m%time%[37m ] %inST%[96m %goMSG% '...\Data\r'[0m
title %goNM%

:: doDATA -- _aprilFools2019
call :doDAT
call :tOUT1
@echo   [37m[ [35m%time%[37m ] %inST%[92m %okMSG%[0m
title %okNM%

:: alertREPLAY -- _aprilFools2019
@echo.
call :tOUT3
@echo   [37m[ [35m%time%[37m ] %inST%[96m %goMSG% '...\Replays'[0m
title %goNM%

:: doREPLAY -- _aprilFools2019
call :doREP
call :tOUT1
@echo   [37m[ [35m%time%[37m ] %inST%[92m %okMSG%[0m
title %okNM%
cd..


:2019ds

if exist "_osu2012spoilerEaster" (
    goto :2012d
)   else (
    goto :2012ds
)

:: alertDATA -- folder _osu2012spoilerEaster
:2012d
cd "_osu2012spoilerEaster"
@echo.

call :tOUT3
@echo   [37m[ [35m%time%[37m ] ^<[36mSTAT[37m^>[93m %ccMSG% 'osu^^!\_osu2012spoilerEaster'[0m
call :tOUT1
@echo   [37m[ [35m%time%[37m ] %inST%[96m %goMSG% '...\Data\r'[0m
title %goNM%

:: doDATA -- _osu2012spoilerEaster
call :doDAT
call :tOUT1
@echo   [37m[ [35m%time%[37m ] %inST%[92m %okMSG%[0m
title %okNM%

:: alertREPLAY -- _osu2012spoilerEaster
@echo.
call :tOUT3
@echo   [37m[ [35m%time%[37m ] %inST%[96m %goMSG% '...\Replays'[0m
title %goNM%

:: doREPLAY -- _osu2012spoilerEaster
call :doREP
call :tOUT1
@echo   [37m[ [35m%time%[37m ] %inST%[92m %okMSG%[0m
title %okNM%
cd..


:2012ds

if exist "_osu2012benchmarkShine" (
    goto :2012db
)   else (
    goto :2012dbs
)

:: alertDATA -- folder _osu2012benchmarkShine
:2012db
cd "_osu2012benchmarkShine"
@echo.

call :tOUT3
@echo   [37m[ [35m%time%[37m ] ^<[36mSTAT[37m^>[93m %ccMSG% 'osu^^!\_osu2012benchmarkShine'[0m
call :tOUT1
@echo   [37m[ [35m%time%[37m ] %inST%[96m %goMSG% '...\Data\r'[0m
title %goNM%

:: doDATA -- _osu2012benchmarkShine
call :doDAT
call :tOUT1
@echo   [37m[ [35m%time%[37m ] %inST%[92m %okMSG%[0m
title %okNM%

:: alertREPLAY -- _osu2012benchmarkShine
@echo.
call :tOUT3
@echo   [37m[ [35m%time%[37m ] %inST%[96m %goMSG% '...\Replays'[0m
title %goNM%

:: doREPLAY -- _osu2012benchmarkShine
call :doREP
call :tOUT1
@echo   [37m[ [35m%time%[37m ] %inST%[92m %okMSG%[0m
title %okNM%
cd..


:2012dbs

if exist "_osu20190410" (
    goto :2019dr
)   else (
    goto :2019drs
)

:: alertDATA -- folder _osu20190410
:2019dr
cd "_osu20190410"
@echo.

call :tOUT3
@echo   [37m[ [35m%time%[37m ] ^<[36mSTAT[37m^>[93m %ccMSG% 'osu^^!\_osu20190410'[0m
call :tOUT1
@echo   [37m[ [35m%time%[37m ] %inST%[96m %goMSG% '...\Data\r'[0m
title %goNM%

:: doDATA -- _osu20190410
call :doDAT
call :tOUT1
@echo   [37m[ [35m%time%[37m ] %inST%[92m %okMSG%[0m
title %okNM%

:: alertREPLAY -- _osu20190410
@echo.
call :tOUT3
@echo   [37m[ [35m%time%[37m ] %inST%[96m %goMSG% '...\Replays'[0m
title %goNM%

:: doREPLAY -- _osu20190410
call :doREP
call :tOUT1
@echo   [37m[ [35m%time%[37m ] %inST%[92m %okMSG%[0m
title %okNM%
cd..


:2019drs

if exist "_osuripple" (
    goto :rippleMNN
)   else (
    goto :rippleSKP
)

:: alertDATA -- folder _osuripple
:rippleMNN
cd "_osuripple"
@echo.

call :tOUT3
@echo   [37m[ [35m%time%[37m ] ^<[36mSTAT[37m^>[93m %ccMSG% 'osu^^!\_osuripple'[0m
call :tOUT1
@echo   [37m[ [35m%time%[37m ] %inST%[96m %goMSG% '...\Data\r'[0m
title %goNM%

:: doDATA -- _osuripple
call :doDAT
call :tOUT1
@echo   [37m[ [35m%time%[37m ] %inST%[92m %okMSG%[0m
title %okNM%

:: alertREPLAY -- _osuripple
@echo.
call :tOUT3
@echo   [37m[ [35m%time%[37m ] %inST%[96m %goMSG% '...\Replays'[0m
title %goNM%

:: doREPLAY -- _osuripple
call :doREP
call :tOUT1
@echo   [37m[ [35m%time%[37m ] %inST%[92m %okMSG%[0m
title %okNM%
cd..


:rippleSKP

:: make file counter work + endlocal

if exist "_osufx" (
    goto :osufxDIR
)   else (
    goto :osufxSKP
)

:: alertDATA -- folder _osufx
:osufxDIR
cd "_osufx"
@echo.

call :tOUT3
@echo   [37m[ [35m%time%[37m ] ^<[36mSTAT[37m^>[93m %ccMSG% 'osu^^!\_osufx'[0m
call :tOUT1
@echo   [37m[ [35m%time%[37m ] %inST%[96m %goMSG% '...\Data\r'[0m
title %goNM%

:: doDATA -- _osufx
call :doDAT
call :tOUT1
@echo   [37m[ [35m%time%[37m ] %inST%[92m %okMSG%[0m
title %okNM%

:: alertREPLAY -- _osufx
@echo.
call :tOUT3
@echo   [37m[ [35m%time%[37m ] %inST%[96m %goMSG% '...\Replays'[0m
title %goNM%

:: doREPLAY -- _osufx
call :doREP
call :tOUT1
@echo   [37m[ [35m%time%[37m ] %inST%[92m %okMSG%[0m
title %okNM%
cd..


:osufxSKP

:: endPROGRAM
:mainCOMP
call :tOUT1
@echo. && @echo   [37m[ [35m%time%[37m ] %inST%[36m %mvMSG% !movQNT!.[0m
@echo   [37m[ [35m%time%[37m ] %inST%[36m %stMSG% !osrQNT!.[0m
echo. && @echo   [37m[ [35m%time%[37m ] %inST%[36m Start time: %startTime%.[0m
@echo   [37m[ [35m%time%[37m ] %inST%[36m Finish time: %time%.[0m && @echo.

title %mnNM%
endlocal && endlocal
@echo   [37m[ i[37m ] [33mPress any key to close the script...[0m && pause > NUL
exit /B
