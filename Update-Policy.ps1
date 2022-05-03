<#
.SYNOPSIS
    Updates Sysmon policy
.DESCRIPTION
    Downloads and updates Sysmon policy
.EXAMPLE
    C:\PS> .\Update-Policy.ps1
#>

# Parameters
param(
    [switch]$NoPrompt,
	[switch]$DownloadOnly,
    [string]$PolicyURL = "https://raw.githubusercontent.com/SwiftOnSecurity/sysmon-config/master/sysmonconfig-export.xml",
	[string]$InstallPath = "C:\Sysmon",
    [string]$PolicyFile = "sysmonconfig.xml"
    )

# Check for Administrator
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)){
  $path = get-location
  $script = $MyInvocation.MyCommand.Name
  $command = "-command set-location `'$path`'; .\$script"
  Start-Process powershell.exe $command -Verb RunAs
  exit
}

write-host "Sysmon policy updater"

# Policy
write-host -nonewline "Downloading policy..."
invoke-webRequest -uri $PolicyURL -outfile "$InstallPath\$PolicyFile" -usebasicparsing
write-host "complete"

# Update
write-host "Updating policy..."
If (-NOT $DownloadOnly) {
	& "$InstallPath\sysmon.exe" -accepteula -c "$InstallPath\$PolicyFile"
	}

# Prompt to close window?
If (-NOT $NoPrompt) {
	write-host "Update complete.`nPress Enter key to close."
	read-host
	}