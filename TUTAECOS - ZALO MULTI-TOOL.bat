@echo off
title Auto-Setup Zalo Multi-Instance (TuTaEcos Premium)
setlocal EnableDelayedExpansion

:: ==========================================
:: UI SETUP (GIAO DIEN)
:: ==========================================
mode con: cols=85 lines=32
color 3F

:: ==========================================
:: 1. AUTO-ELEVATE TO ADMINISTRATOR
:: ==========================================
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: ==========================================
:: 2. LANGUAGE SELECTION
:: ==========================================
cls
echo.
echo    ======================================================================
echo                        TUTAECOS - ZALO MULTI-TOOL
echo    ======================================================================
echo.
echo    LANGUAGE SELECTION / CHON NGON NGU
echo    ----------------------------------
echo    [1] English
echo    [2] Tieng Viet (Vietnamese)
echo.
set /p LangChoice="   Select language / Chon ngon ngu (1 or 2): "
cls

if "%LangChoice%"=="2" (
    set "L_TITLE=TRINH TAO ZALO KHONG GIOI HAN - TUTAECOS"
    set "L_ERR_NOZALO=[LOI] Khong tim thay Zalo goc tren may tinh nay."
    set "L_PROMPT_NUM=Nhap so thu tu Zalo can tao (VD: 2, 3, 4, 5...) : "
    set "L_CLEANING=[i] Dang don dep..."
    set "L_MENU_HEADER=CHON VI TRI LUU TRU DU LIEU"
    set "L_MENU_DESC=Ban muon luu du lieu cho tai khoan Zalo nay o dau?"
    set "L_OPT1=[1] Mac dinh o C: (Thu muc an cach ly an toan)"
    set "L_OPT2=[2] Phan vung / Thu muc khac (VD: D:\, E:\, F:\...)"
    set "L_PROMPT_CHOICE=Nhap lua chon cua ban (1 hoac 2)   : "
    set "L_PROMPT_PATH=Chon phan vung chua du lieu (VD: D, E, F...)    : "
    set "L_PROGRESS=DANG XU LY SETUP..."
    set "L_STEP1=[1/6] Dang tao tai khoan an ("
    set "L_STEP2=[2/6] Dang nhan ban ung dung Zalo..."
    set "L_STEP3_PREP=[3/6] Dang chuan bi tao Phim tat..."
    set "L_STEP4_R=[4/6] Dang dinh tuyen du lieu den: "
    set "L_STEP4_D=[4/6] Da chon [1]. Su dung o C: mac dinh."
    set "L_STEP5=[5/6] Dang hoan thien Phim tat..."
    set "L_STEP6=[6/6] Dang xuat thong tin bao mat ra log..."
    set "L_COMPLETE=THIET LAP HOAN TAT THANH CONG!"
    set "L_SHORTCUT=Phim tat tren Desktop: "
    set "L_PASS=MAT KHAU DANG NHAP   : "
    set "L_LOG=Lich su luu tai      : "
    set "L_DATA=Duong dan du lieu    : "
    set "L_LOG_INST=Tai khoan Zalo: "
    set "L_LOG_USER=Nguoi dung: "
    set "L_LOG_PASS=Mat khau: "
    set "L_LOG_DATE=Ngay tao: "
    set "L_PRESSKEY=Nhan phim bat ky de thoat..."
) else (
    set "L_TITLE=THE INFINITE ZALO GENERATOR - TUTAECOS"
    set "L_ERR_NOZALO=[ERROR] Cannot find original Zalo installed on this PC."
    set "L_PROMPT_NUM=Enter the Zalo number (e.g., 2, 3, 4, 5) : "
    set "L_CLEANING=[i] Cleaning up..."
    set "L_MENU_HEADER=CHOOSE DATA STORAGE LOCATION"
    set "L_MENU_DESC=Where do you want to save the data for this Zalo account?"
    set "L_OPT1=[1] Default C: Drive (Isolated hidden folder)"
    set "L_OPT2=[2] Custom Partition (e.g., D:\, E:\, F:\...)"
    set "L_PROMPT_CHOICE=Enter your choice (1 or 2)         : "
    set "L_PROMPT_PATH=Select the partition containing the data (e.g., D, E, F)      : "
    set "L_PROGRESS=PROCESSING SETUP..."
    set "L_STEP1=[1/6] Creating hidden account ("
    set "L_STEP2=[2/6] Cloning Zalo application..."
    set "L_STEP3_PREP=[3/6] Preparing Shortcut Script..."
    set "L_STEP4_R=[4/6] Routing data entirely to: "
    set "L_STEP4_D=[4/6] Option [1] selected. Using default C: drive."
    set "L_STEP5=[5/6] Finalizing Shortcut..."
    set "L_STEP6=[6/6] Exporting credentials to log..."
    set "L_COMPLETE=SETUP COMPLETED SUCCESSFULLY!"
    set "L_SHORTCUT=Desktop Shortcut     : "
    set "L_PASS=LOGIN PASSWORD       : "
    set "L_LOG=Credentials Log      : "
    set "L_DATA=Data Path            : "
    set "L_LOG_INST=Zalo Instance: "
    set "L_LOG_USER=Windows User:  "
    set "L_LOG_PASS=Password:      "
    set "L_LOG_DATE=Created on:    "
    set "L_PRESSKEY=Press any key to exit..."
)

:: ==========================================
:: 3. DYNAMIC PATH DETECTION (Fix for All Languages)
:: ==========================================
set "ZaloDir=%LOCALAPPDATA%\Programs\Zalo"
set "PublicZalo=C:\ZaloMulti"
set "ZaloExe=%PublicZalo%\Zalo.exe"

:: Use PowerShell to find the actual active Desktop path (Anh/Viet/Phap...)
for /f "delims=" %%i in ('powershell -command "[Environment]::GetFolderPath('Desktop')"') do set "DESKTOP_DIR=%%i"
set "LogFile=%DESKTOP_DIR%\Zalo_Clone_Log.txt"

if not exist "%ZaloDir%\Zalo.exe" (
    echo.
    echo    !L_ERR_NOZALO!
    pause
    exit /b
)

:: ==========================================
:: 4. USER INPUT & AUTO-CLEANUP
:: ==========================================
echo.
echo    ======================================================================
echo               !L_TITLE!
echo    ======================================================================
echo.
set /p InstanceNum="   !L_PROMPT_NUM!"
set "AccName=zalo!InstanceNum!"

net user !AccName! >nul 2>&1
if !errorlevel! equ 0 (
    echo    !L_CLEANING!
    net user !AccName! /delete >nul 2>&1
)

:: ==========================================
:: 5. STORAGE LOCATION MENU
:: ==========================================
echo.
echo    ----------------------------------------------------------------------
echo    !L_MENU_HEADER!
echo    ----------------------------------------------------------------------
echo    !L_MENU_DESC!
echo    !L_OPT1!
echo    !L_OPT2!
echo.
set /p StorageChoice="   !L_PROMPT_CHOICE!"

set "CustomDataPath="
if "!StorageChoice!"=="2" (
    echo.
    set /p CustomDataPath="   !L_PROMPT_PATH!"
    
    set "tempPath=!CustomDataPath!"
    if "!tempPath:~1,1!"=="" set "tempPath=!tempPath!:\"
    set "tempPath=!tempPath:"=!"
    for /f "delims=" %%A in ("!tempPath!") do set "CustomDataPath=%%A"
)

set "AccPass=Zl@!RANDOM!x!RANDOM!"

cls
echo.
echo    ======================================================================
echo    !L_PROGRESS!
echo    ======================================================================
echo.

echo    !L_STEP1!!AccName!)...
net user !AccName! !AccPass! /add >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v !AccName! /t REG_DWORD /d 0 /f >nul 2>&1

echo    !L_STEP2!
if not exist "%PublicZalo%" mkdir "%PublicZalo%"
xcopy "%ZaloDir%" "%PublicZalo%" /E /I /H /Y /Q >nul 2>&1
icacls "%PublicZalo%" /grant Users:(OI)(CI)F /T >nul 2>&1

echo    !L_STEP3_PREP!
set "PS_SCRIPT=%TEMP%\CreateZaloShortcut.ps1"
echo $wshell = New-Object -ComObject WScript.Shell > "%PS_SCRIPT%"
echo $shortcut = $wshell.CreateShortcut('%DESKTOP_DIR%\Zalo %InstanceNum%.lnk') >> "%PS_SCRIPT%"
echo $shortcut.TargetPath = 'C:\Windows\System32\runas.exe' >> "%PS_SCRIPT%"
echo $shortcut.IconLocation = '%ZaloExe%, 0' >> "%PS_SCRIPT%"

:: ==========================================
:: 6. ROUTING LOGIC
:: ==========================================
if "!CustomDataPath!"=="" goto SetupOption1

:SetupOption2
if "!CustomDataPath:~-1!"=="\" set "CustomDataPath=!CustomDataPath:~0,-1!"

set "MasterDataPath=!CustomDataPath!\Zalo_Data"
set "InstanceDataPath=!MasterDataPath!\!AccName!_Data"

echo    !L_STEP4_R!!InstanceDataPath!...
if not exist "!MasterDataPath!" mkdir "!MasterDataPath!" >nul 2>&1
mkdir "!InstanceDataPath!" >nul 2>&1
icacls "!InstanceDataPath!" /grant Users:(OI)(CI)F /T >nul 2>&1

set "LauncherPath=!InstanceDataPath!\Launch_!AccName!.bat"
echo @echo off > "!LauncherPath!"
echo dir /al "%%LOCALAPPDATA%%\ZaloPC" ^>nul 2^>^&1 >> "!LauncherPath!"
echo if errorlevel 1 ( >> "!LauncherPath!"
echo      if exist "%%LOCALAPPDATA%%\ZaloPC" rmdir /s /q "%%LOCALAPPDATA%%\ZaloPC" >> "!LauncherPath!"
echo      mklink /J "%%LOCALAPPDATA%%\ZaloPC" "!InstanceDataPath!" ^>nul 2^>^&1 >> "!LauncherPath!"
echo ) >> "!LauncherPath!"
echo start "" "%ZaloExe%" >> "!LauncherPath!"

echo $shortcut.Arguments = '/user:!AccName! /savecred "!LauncherPath!"' >> "%PS_SCRIPT%"
set "LogDataPath=!InstanceDataPath!"
goto BuildShortcut

:SetupOption1
echo    !L_STEP4_D!
echo $shortcut.Arguments = '/user:!AccName! /savecred "%ZaloExe%"' >> "%PS_SCRIPT%"
set "LogDataPath=C: Drive"
goto BuildShortcut

:BuildShortcut
:: ==========================================
:: 7. FINALIZE & EXPORT
:: ==========================================
echo    !L_STEP5!
echo $shortcut.Save() >> "%PS_SCRIPT%"
powershell -ExecutionPolicy Bypass -File "%PS_SCRIPT%"
del "%PS_SCRIPT%"

echo    !L_STEP6!
echo ------------------------------------------ >> "%LogFile%"
echo !L_LOG_INST! %InstanceNum% >> "%LogFile%"
echo !L_LOG_USER! !AccName! >> "%LogFile%"
echo !L_LOG_PASS! !AccPass! >> "%LogFile%"
echo !L_DATA! !LogDataPath! >> "%LogFile%"
echo !L_LOG_DATE! %date% %time% >> "%LogFile%"
echo ------------------------------------------ >> "%LogFile%"

echo.
echo    ======================================================================
echo    !L_COMPLETE!
echo    ======================================================================
echo.
echo      + !L_SHORTCUT! Zalo %InstanceNum%
echo      + !L_DATA! !LogDataPath!
echo      + !L_LOG! Zalo_Clone_Log.txt
echo.
echo      *************************************************
echo        !L_PASS! !AccPass!
echo      *************************************************
echo.
echo    !L_PRESSKEY!
pause >nul