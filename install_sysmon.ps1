# Sysmon installer script
clear-host
write-host "`n`n`n`n`n`nSysmon installer`n"

# Download
write-host -nonewline "Downloading Sysmon..."
new-item -force -path "C:\Sysmon" -itemtype directory | out-null
$smURL = "https://download.sysinternals.com/files/Sysmon.zip"
$smDest = "C:\Sysmon\sysmon.zip"
invoke-webRequest -uri $smURL -outfile $smDest -usebasicparsing
write-host "complete"

# Unzip
write-host -nonewline "Unzipping Sysmon..."
expand-archive -force -literalpath "c:\sysmon\sysmon.zip" -destinationpath "c:\sysmon"
remove-item c:\sysmon\sysmon.zip
write-host "complete"

# Policy
write-host -nonewline "Downloading policy..."
$smURL = "https://raw.githubusercontent.com/SwiftOnSecurity/sysmon-config/master/sysmonconfig-export.xml"
$smDest = "C:\Sysmon\sysmonconfig.xml"
invoke-webRequest -uri $smURL -outfile $smDest -usebasicparsing
write-host "complete"

# Install
write-host -nonewline "Installing Sysmon..."
start-process powershell -verb runas "c:\sysmon\sysmon.exe -accepteula -l -n -i c:\sysmon\sysmonconfig.xml"
copy-item update_policy.ps1 c:\sysmon\
write-host "complete"

# Complete
write-host "`nPress Enter key to close..."
read-host
