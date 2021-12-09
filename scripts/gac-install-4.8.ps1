param([String]$dllPath)

Import-Module WebAdministration


if([IntPtr]::size -eq 8) { Write-Host 'x64' } else { Write-Host 'x86' }

$gacutil = "C:\Program Files (x86)\Microsoft SDKs\Windows\v10.0A\bin\NETFX 4.8 Tools\gacutil.exe"
$poolName = "SharePoint - 80"
$appCmd = "C:\Windows\System32\inetsrv\appcmd.exe"

Write-Host "[x] dll path is $dllPath"
Write-Host "[x] running gacutil"
Write-Host "-----------------------------------"

& $gacutil -i $dllPath -f


Write-Host "[x] restarting pool named $poolName"
Write-Host "-----------------------------------"

Write-Host "App Pool Recycling Started...."
& $appCmd list apppools /state:Started /xml | & $appCmd recycle apppools /in 
Write-Host "App Pool Recycling Completed"

Write-Host "[x] sleeping for 5 secs"
Write-Host "-----------------------------------"

return

sleep(5)

Write-Host "[x] restarting sharepoint timer service"
Write-Host "-----------------------------------"

net stop SPTimerV4
net start SPTimerV4

Write-Host "[x] there are all iis working pools:"
Write-Host "-----------------------------------"

& $appCmd list wp