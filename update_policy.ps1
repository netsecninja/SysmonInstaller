# Update Sysmon policy script
clear-host
write-host "`n`n`n`n`n`nUpdate Sysmon policy`n"

# Policy
write-host -nonewline "Downloading policy..."
$smURL = "https://raw.githubusercontent.com/SwiftOnSecurity/sysmon-config/master/sysmonconfig-export.xml"
$smDest = "C:\Sysmon\sysmonconfig.xml"
invoke-webRequest -uri $smURL -outfile $smDest -usebasicparsing
write-host "complete"

# update
write-host -nonewline "Updating policy..."
start-process powershell -verb runas "c:\sysmon\sysmon.exe -accepteula -l -n -c c:\sysmon\sysmonconfig.xml"
write-host "complete"

write-host "`nPress Enter key to close."
read-host
