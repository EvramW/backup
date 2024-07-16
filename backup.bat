@echo off
setlocal enabledelayedexpansion

:: Variables
:: تغيير عنوان الملف المراد اخذ نسخة احتياطية منه
set "source=D:\CustomerDatabase\data_live\AATCDatabaseV5.03.accdb"
:: المجلد الهدف المراد عمل نسخة احتياطية به
set "backupBaseDir=D:\backup"
set "batDir=%backupBaseDir%\bat"

:: Ensure bat directory exists
if not exist "%batDir%" mkdir "%batDir%"

:: Create individual batch files for each day of the week
for %%i in (1 2 3 4 5 6 7) do (
    set "backupDir=!backupBaseDir!\%%i"
    set "batFile=!batDir!\%%i.bat"

    echo @echo off > "!batFile!"
    echo setlocal >> "!batFile!"
    echo. >> "!batFile!"

    echo :: Variables >> "!batFile!"
    echo set "source=%source%" >> "!batFile!"
    echo set "backupDir=!backupDir!" >> "!batFile!"
    echo. >> "!batFile!"

    echo :: Ensure backup directory exists >> "!batFile!"
    echo if not exist "!backupDir!" mkdir "!backupDir!" >> "!batFile!"
    echo. >> "!batFile!"

    echo :: Close MS Access if it's open >> "!batFile!"
    echo taskkill /F /IM msaccess.exe >> "!batFile!"
    echo. >> "!batFile!"

    echo :: Backup the database >> "!batFile!"
    echo xcopy "%source%" "!backupDir!\" /Y /I >> "!batFile!"
    echo. >> "!batFile!"

    echo :: End >> "!batFile!"
    echo endlocal >> "!batFile!"
    echo exit /b >> "!batFile!"
)

:: Schedule tasks using schtasks
schtasks /Create /tr "%batDir%\1.bat" /tn "VeryEasy1" /sc weekly /st 12:00 /D SUN
schtasks /Create /tr "%batDir%\2.bat" /tn "VeryEasy2" /sc weekly /st 12:00 /D MON
schtasks /Create /tr "%batDir%\3.bat" /tn "VeryEasy3" /sc weekly /st 12:00 /D TUE
schtasks /Create /tr "%batDir%\4.bat" /tn "VeryEasy4" /sc weekly /st 12:00 /D WED
schtasks /Create /tr "%batDir%\5.bat" /tn "VeryEasy5" /sc weekly /st 12:00 /D THU
schtasks /Create /tr "%batDir%\6.bat" /tn "VeryEasy6" /sc weekly /st 12:00 /D FRI
schtasks /Create /tr "%batDir%\7.bat" /tn "VeryEasy7" /sc weekly /st 12:00 /D SAT

:: Notify the user
echo Batch files and scheduled tasks created successfully.
endlocal
exit /b
