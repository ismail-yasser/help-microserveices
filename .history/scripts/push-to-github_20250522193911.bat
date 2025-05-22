@echo off
setlocal enabledelayedexpansion

echo ===================================================
echo GitHub Push Helper
echo ===================================================
echo.

set TEAM_NAME=%1
set MEMBER_NAME=%2
set COMMIT_MESSAGE=%3

if "%1"=="" (
    set /p TEAM_NAME=Enter your team name (e.g., teamX): 
)

if "%2"=="" (
    set /p MEMBER_NAME=Enter your name (e.g., memberY): 
)

if "%3"=="" (
    set /p COMMIT_MESSAGE=Enter commit message: 
)

set BRANCH_NAME=%TEAM_NAME%-%MEMBER_NAME%

echo Preparing to push changes to GitHub branch: %BRANCH_NAME%
echo.

:: Check if git is available
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Git is not installed or not in the PATH
    echo Please install Git and try again
    exit /b 1
)

:: Check if current directory is a git repository
if not exist .git (
    cd ..
    if not exist .git (
        echo ERROR: Not in a Git repository
        echo Please navigate to your project's root directory and try again
        exit /b 1
    )
)

:: Check if the branch exists and create if not
git show-ref --verify --quiet refs/heads/%BRANCH_NAME%
if %errorlevel% neq 0 (
    echo Branch %BRANCH_NAME% does not exist. Creating new branch...
    git checkout -b %BRANCH_NAME%
) else (
    echo Branch %BRANCH_NAME% exists. Switching to branch...
    git checkout %BRANCH_NAME%
)

echo.
echo Current branch: %BRANCH_NAME%
echo.

echo ===================================================
echo Files to be committed:
echo ===================================================
echo.

:: Show status
git status

echo.
echo ===================================================
echo Preparing commit
echo ===================================================
echo.

:: Ask for confirmation
set /p CONFIRM=Do you want to add all files and commit changes? (y/n): 
if /i "%CONFIRM%"=="y" (
    :: Add all files
    echo Adding files to staging area...
    git add .
    
    :: Commit changes
    echo Committing changes...
    git commit -m "%COMMIT_MESSAGE%"
    
    :: Push to remote
    echo Pushing changes to GitHub...
    git push -u origin %BRANCH_NAME%
    
    if %errorlevel% neq 0 (
        echo.
        echo ERROR: Push failed. Please check your GitHub credentials and try again.
        exit /b 1
    )
    
    echo.
    echo ===================================================
    echo Push successful!
    echo ===================================================
    echo.
    echo Branch: %BRANCH_NAME%
    echo Commit message: %COMMIT_MESSAGE%
    echo.
    echo Your Kubernetes files, API documentation, and code updates
    echo have been pushed to GitHub.
    echo.
) else (
    echo.
    echo Operation cancelled. No changes were committed or pushed.
    echo.
)

exit /b 0
