#
# This script is to be used to remove all PowerShell personalizations along with all the installed components.
# Intentially not worried about the font's. Leave that up to individuals to determine if they want to remove or not.
#
# Ensure the script can run with elevated privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Please run this script as an Administrator!"
    break
}

try {
# Check if the source file exists
if (Test-Path -Path $PROFILE) {
    # If the file exists, delete it from the PowerShell folder
    Remove-Item -Path $PROFILE -Force
    Write-Host "PowerShell Profile deleted successfully."
} else {
    Write-Host "PowerShell Profile file does not exist @ [$PROFILE]."
}

}
catch {
    Write-Error "Failed to remove PowerShell Profile or not installed. Error: $_"
}

#
# In the original setup.ps1 deployment, and if a user has their Documents folder moved to OneDrive, the backup is created at @HOME\Documents\Powershell. 
# This means that if a user has moved documents into OneDrive, the above folder is either empty or doesn't exist. Therefore the setup.ps1 actually recreates the folder.                                                                          
# Not sure this is a good idea - not everyone may have their documents redirected to their OneDrive, thus the below could delete their "actual" Documents folder.
# Leaving it here just incase *shrug*
#
#try {
#    $backuppowershell = "$HOME\Documents"
#    if (Test-Path -Path $backuppowershell) {
#        Remove-Item -Path $backuppowershell -Recurse -Force
#        Write-Host "Folder '$backuppowershell' existed and has been deleted."
#    } else {
#        Write-Host "Folder '$backuppowershell' does not exist."
#    }
#}
#catch {
#    Write-Error "Failed to remove folder or not present. Error: $_"
#}

try {
    $backuppowershellFile = "$HOME\oldprofile.ps1"
    if (Test-Path -Path $backuppowershellFile) {
        Remove-Item -Path $backuppowershellFile -Recurse -Force
        Write-Host "File '$backuppowershellFile' existed and has been deleted."
    } else {
        Write-Host "File '$backuppowershellFile' does not exist."
    }
}
catch {
    Write-Error "Failed to remove '$backuppowershellFile' or not present. Error: $_"
}

	
try {
    $ohmyposhPath = "$env:localappdata\oh-my-posh"
    if (Test-Path -Path $ohmyposhPath) {
        Remove-Item -Path $ohmyposhPath -Recurse -Force
        Write-Host "Folder '$ohmyposhPath' existed and has been deleted."
    } else {
        Write-Host "Folder '$ohmyposhPath' does not exist."
    }
    winget uninstall -e --id JanDeDobbeleer.OhMyPosh
}
catch {
    Write-Error "Failed to uninstall Oh-My-Posh or not installed. Error: $_"
}

# Terminal Icons Install
try {
    UnInstall-Module -Name Terminal-Icons -Force
}
catch {
    Write-Error "Failed to uninstall Terminal Icons module or not installed. Error: $_"
}

# zoxide UnInstall
try {
    $zoxidePath = "$env:localappdata\zoxide"
    if (Test-Path -Path $zoxidePath) {
        Remove-Item -Path $zoxidePath -Recurse -Force
        Write-Host "Folder '$zoxidePath' existed and has been deleted."
    } else {
        Write-Host "Folder '$zoxidePath' does not exist."
    }
    winget uninstall -e --id ajeetdsouza.zoxide
    Write-Host "zoxide uninstalled successfully."
}
catch {
    Write-Error "Failed to uninstall zoxide. Error: $_"
}

# Final check and message to the user
if (!(Test-Path -Path $PROFILE) -and (winget list --name "OhMyPosh" -e) -and (winget list --name "zoxide" -e)) {
    Write-Host "Uninstall completed successfully. Please restart your PowerShell session to apply changes."
} else {
    Write-Warning "Uninstall completed with errors. Please check the error messages above."
}