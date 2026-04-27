@echo off
title Zalo Multi-Instance Uninstaller (TuTaEcos Premium)
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
echo                     TUTAECOS - ZALO CLONE UNINSTALLER
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
    set "L_TITLE=TRINH GO CAI DAT ZALO CLONE - TUTAECOS"
    set "L_PROMPT_NUM=Nhap so thu tu Zalo can XOA (VD: 2, 3, 4, 5,...) : "
    set "L_WARN=CANH BAO: Ban co CHAC CHAN muon xoa hoan toan Zalo"
    set "L_YN=(Y/N) : "
    set "L_CANCEL=Da huy thao tac xoa."
    set "L_PROGRESS=DANG TIEN HANH XOA DU LIEU..."
    set "L_STEP1=[1/4] Dang xoa tai khoan Windows an..."
    set "L_STEP2=[2/4] Dang xoa phim tat tren Desktop..."
    set "L_STEP3=[3/4] Dang don dep ho so nguoi dung tren o C..."
    set "L_STEP4=[4/4] Kiem tra du lieu tren phan vung tuy chinh..."
    set "L_PROMPT_DRIVE=Ban co luu data tren o khac khong? (VD: D, E). Nhan Enter de bo qua: "
    set "L_COMPLETE=DA XOA THANH CONG!"
    set "L_PRESSKEY=Nhan phim bat ky de thoat..."
    set "L_NOTFOUND=[i] Khong tim thay tai khoan nay tren he thong."
) else (
    set "L_TITLE=ZALO CLONE UNINSTALLER - TUTAECOS"
    set "L_PROMPT_NUM=Enter the Zalo number to DELETE (e.g., 2, 3, 4, 5) : "
    set "L_WARN=WARNING: Are you SURE you want to completely delete Zalo"
    set "L_YN=(Y/N) : "
    set "L_CANCEL=Deletion cancelled."
    set "L_PROGRESS=DELETING DATA..."
    set "L_STEP1=[1/4] Deleting hidden Windows account..."
    set "L_STEP2=[2/4] Deleting Desktop shortcut..."
    set "L_STEP3=[3/4] Cleaning up user profile on C: drive..."
    set "L_STEP4=[4/4] Checking for custom partition data..."
    set "L_PROMPT_DRIVE=Did you save data on another drive? (e.g., D, E). Press Enter to skip: "
    set "L_COMPLETE=SUCCESSFULLY DELETED!"
    set "L_PRESSKEY=Press any key to exit..."
    set "L_NOTFOUND=[i] This account was not found on the system."
)

for /f "delims=" %%i in ('powershell -command "[Environment]::GetFolderPath('Desktop')"') do set "DESKTOP_DIR=%%i"

:: ==========================================
:: 3. USER INPUT PHASE
:: ==========================================
echo.
echo    ======================================================================
echo               !L_TITLE!
echo    ======================================================================
echo.
set /p InstanceNum="   !L_PROMPT_NUM!"
set "AccName=zalo!InstanceNum!"

:: Check if account exists
net user !AccName! >nul 2>&1
if !errorlevel! neq 0 (
    echo.
    echo    !L_NOTFOUND!
    echo    !L_PRESSKEY!
    pause >nul
    exit /b
)

echo.
echo    ----------------------------------------------------------------------
echo    !L_WARN! %InstanceNum%?
echo    ----------------------------------------------------------------------
set /p Confirm="   !L_YN!"
if /I not "!Confirm!"=="Y" (
    echo.
    echo    !L_CANCEL!
    echo    !L_PRESSKEY!
    pause >nul
    exit /b
)

:: ==========================================
:: 4. CUSTOM DRIVE CHECK
:: ==========================================
echo.
set /p CustomDrive="   !L_PROMPT_DRIVE!"

cls
echo.
echo    ======================================================================
echo    !L_PROGRESS!
echo    ======================================================================
echo.

:: ==========================================
:: 5. DELETION LOGIC
:: ==========================================
echo    !L_STEP1!
net user !AccName! /delete >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /v !AccName! /f >nul 2>&1

echo    !L_STEP2!
if exist "!DESKTOP_DIR!\Zalo %InstanceNum%.lnk" del /q /f "!DESKTOP_DIR!\Zalo %InstanceNum%.lnk" >nul 2>&1

echo    !L_STEP3!
:: Using WMI to properly delete the user profile from Windows Registry and C: drive
wmic path win32_userprofile where "LocalPath='C:\\Users\\!AccName!'" delete >nul 2>&1
if exist "C:\Users\!AccName!" rmdir /s /q "C:\Users\!AccName!" >nul 2>&1

echo    !L_STEP4!
if not "!CustomDrive!"=="" (
    :: Format user input to ensure it's just the drive letter with colon (e.g., E:)
    set "tempDrive=!CustomDrive!"
    if "!tempDrive:~1,1!"=="" set "tempDrive=!tempDrive!:"
    set "tempDrive=!tempDrive:~0,2!"
    
    set "CustomDataPath=!tempDrive!\Zalo_Data\!AccName!_Data"
    if exist "!CustomDataPath!" (
        rmdir /s /q "!CustomDataPath!" >nul 2>&1
        echo      - Removed: !CustomDataPath!
    )
)

echo.
echo    ======================================================================
echo    !L_COMPLETE!
echo    ======================================================================
echo.
echo    !L_PRESSKEY!
pause >nul