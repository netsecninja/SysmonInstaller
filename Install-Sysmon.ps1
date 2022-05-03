<#
.SYNOPSIS
    Installs Sysmon
.DESCRIPTION
    Installs Sysmon
.EXAMPLE
    C:\PS> .\Install-Sysmon.ps1
#>

# Parameters
param(
    [switch]$NoPrompt,
    [string]$SysmonURL = "https://download.sysinternals.com/files/Sysmon.zip",
	[string]$InstallPath = "C:\Sysmon"
    )

$path = get-location

If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)){
  $script = $MyInvocation.MyCommand.Name
  $command = "-command set-location `'$path`'; .\$script"
  Start-Process powershell.exe $command -Verb RunAs
  exit
}

write-output "Sysmon installer"

# Download
write-host -nonewline "Downloading Sysmon..."
new-item -force -path "$InstallPath" -itemtype directory | out-null
invoke-webRequest -uri $SysmonURL -outfile "$InstallPath\sysmon.zip" -usebasicparsing
write-host "complete"

# Unzip
write-host -nonewline "Unzipping Sysmon..."
expand-archive -force -literalpath "$InstallPath\sysmon.zip" -destinationpath "$InstallPath"
remove-item "$InstallPath\sysmon.zip"
write-host "complete"

# Policy
copy-item "$path\Sysmon\Update-Policy.ps1" "$InstallPath"
& "$InstallPath\Update-Policy.ps1" -NoPrompt -DownloadOnly
<# write-host -nonewline "Downloading policy..."
$smURL = "https://raw.githubusercontent.com/SwiftOnSecurity/sysmon-config/master/sysmonconfig-export.xml"
$smDest = "C:\Sysmon\sysmonconfig.xml"
invoke-webRequest -uri $smURL -outfile $smDest -usebasicparsing
write-host "complete" #>

# Install
if (get-service sysmon -ErrorAction SilentlyContinue) {
	write-host "Removing existing Sysmon..."
	& "$InstallPath\sysmon.exe" -u
	}
write-host "Installing Sysmon..."
& "$InstallPath\sysmon.exe" -accepteula -i "$InstallPath\sysmonconfig.xml"

# Prompt to close window?
If (-NOT $NoPrompt) {
	write-host "`nInstall complete.`nPress Enter key to close..."
	read-host
	}