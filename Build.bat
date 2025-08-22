@echo off
cls
SETLOCAL

:: =================================================================================
::          UNREAL ENGINE PROJECT BUILD SCRIPT - CONFIGURE YOUR BUILD HERE
:: =================================================================================

:: 1. Set your Unreal Engine installation directory and version
::    (Example: UE_5.3, UE_5.4, etc.)
SET ENGINE_INSTALL_DIR=C:\Program Files\Epic Games
SET ENGINE_VERSION=UE_5.6

:: 2. Set the full path to your project's root folder
::    (This is the folder that contains the .uproject file)
SET PROJECT_ROOT_PATH=D:\_Unreal\UnrealProjects\Stack-O-Jam-2025

:: 3. Set the name of your project (without the .uproject extension)
SET PROJECT_NAME=StackOBot

:: =================================================================================
::            (You shouldn't need to change anything below this line)
:: =================================================================================

:: --- User Prompt for Build Configuration ---
:AskBuildConfig
ECHO.
ECHO Please select the build configuration:
ECHO   [1] Shipping
ECHO   [2] Development
ECHO.
SET /P BUILD_CHOICE="Enter your choice (1 or 2): "

IF /I "%BUILD_CHOICE%"=="1" (
    SET BUILD_CONFIG=Shipping
    GOTO :Continue
)
IF /I "%BUILD_CHOICE%"=="S" (
    SET BUILD_CONFIG=Shipping
    GOTO :Continue
)
IF /I "%BUILD_CHOICE%"=="2" (
    SET BUILD_CONFIG=Development
    GOTO :Continue
)
IF /I "%BUILD_CHOICE%"=="D" (
    SET BUILD_CONFIG=Development
    GOTO :Continue
)

ECHO.
ECHO Invalid choice. Please press 1 or 2.
PAUSE
cls
GOTO :AskBuildConfig

:Continue
cls

:: --- Derived Paths (automatically calculated) ---
SET ENGINE_ROOT=%ENGINE_INSTALL_DIR%\%ENGINE_VERSION%
SET AUTOMATION_TOOL=%ENGINE_ROOT%\Engine\Binaries\DotNET\AutomationTool\AutomationTool.exe
SET UNREAL_EXE=%ENGINE_ROOT%\Engine\Binaries\Win64\UnrealEditor-Cmd.exe
SET UPROJECT_FILE=%PROJECT_ROOT_PATH%\%PROJECT_NAME%.uproject
SET ARCHIVE_DIR=%PROJECT_ROOT_PATH%\Build\%BUILD_CONFIG%

:: --- Pre-flight Checks & Info ---
ECHO.
ECHO ============================ BUILD CONFIGURATION ============================
ECHO Engine Path:      "%ENGINE_ROOT%"
ECHO Project File:     "%UPROJECT_FILE%"
ECHO Build Target:     %PROJECT_NAME%
ECHO Configuration:    %BUILD_CONFIG%
ECHO Archive Directory: "%ARCHIVE_DIR%"
ECHO =============================================================================
ECHO.

IF NOT EXIST "%AUTOMATION_TOOL%" (
    ECHO ERROR: AutomationTool.exe not found at the specified engine path.
    ECHO Please check your ENGINE_INSTALL_DIR and ENGINE_VERSION variables.
    GOTO :End
)

IF NOT EXIST "%UPROJECT_FILE%" (
    ECHO ERROR: .uproject file not found at the specified project path.
    ECHO Please check your PROJECT_ROOT_PATH and PROJECT_NAME variables.
    GOTO :End
)

ECHO Starting build process in 5 seconds... Press Ctrl+C to cancel.
TIMEOUT /T 5 /NOBREAK > NUL
ECHO.

:: --- Execute the Build Command ---
:: The caret (^) character is used to break the long command into multiple lines for readability
"%AUTOMATION_TOOL%" ^
    -ScriptsForProject="%UPROJECT_FILE%" ^
    BuildCookRun ^
    -nocompileeditor -installed -nop4 ^
    -project="%UPROJECT_FILE%" ^
    -cook -stage -archive -archivedirectory="%ARCHIVE_DIR%" ^
    -package ^
    -unrealexe="%UNREAL_EXE%" ^
    -ddc=InstalledDerivedDataBackendGraph ^
    -pak -prereqs -nodebuginfo ^
    -targetplatform=Win64 ^
    -build ^
    -target=%PROJECT_NAME% ^
    -clientconfig=%BUILD_CONFIG%

:: --- Completion ---
ECHO.
ECHO =============================================================================
ECHO Build process finished. Check the console output above for any errors.
ECHO Built project can be found in: "%ARCHIVE_DIR%"
ECHO =============================================================================
ECHO.

:End
ENDLOCAL
PAUSE