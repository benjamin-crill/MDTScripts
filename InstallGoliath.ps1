# PowerShell Wrapper for MDT, Standalone and Chocolatey Installation - (C)2015 xenappblog.com 
# Example 1: Start-Process "XenDesktopServerSetup.exe" -ArgumentList $unattendedArgs -Wait -Passthru
# Example 2 Powershell: Start-Process powershell.exe -ExecutionPolicy bypass -file $Destination
# Example 3 EXE (Always use ' '):
# $UnattendedArgs='/qn'
# (Start-Process "$PackageName.$InstallerType" $UnattendedArgs -Wait -Passthru).ExitCode
# Example 4 MSI (Always use " "):
# $UnattendedArgs = "/i $PackageName.$InstallerType ALLUSERS=1 /qn /liewa $LogApp"
# (Start-Process msiexec.exe -ArgumentList $UnattendedArgs -Wait -Passthru).ExitCode

Clear-Host
Write-Verbose "Setting Arguments" -Verbose
$StartDTM = (Get-Date)

#Variables setup
$Vendor = "Goliath"
$Product = "Performance Monitor"
$Version = "12.0"
$URL = $Evergreen.uri
$InstallerType = "msi"
$Source = "$PackageName" + "." + "$InstallerType"
$LogPS = "${env:SystemRoot}" + "\Temp\$Vendor $Product $Version PS Wrapper.log"
$LogApp = "${env:SystemRoot}" + "\Temp\$PackageName.log"
$Destination = "${env:ChocoRepository}" + "\$Vendor\$Product\$Version\$packageName.$installerType"
$UnattendedArgs = " InstallAgent.exe /S:SilentArgs.ini"
$ProgressPreference = 'SilentlyContinue'
$serveraddress = ""

Start-Transcript $LogPS | Out-Null
  
CD $Version

Write-Verbose "Starting Installation of $Vendor $Product $Version" -Verbose
(Start-Process InstallAgent.exe -ArgumentList "/S:SetupVars.ini" -Wait -Passthru).ExitCode

Write-Verbose "Customization" -Verbose

Stop-Service -Name "MonitorIT Agent Service"
Set-ItemProperty -Path "HKLM:\Software\Breakout Technologies\MonitorIT\Agent" -Name "ServerAddr" -Value $serveraddress
Set-ItemProperty -Path "HKLM:\Software\Breakout Technologies\MonitorIT\Agent" -Name "LoginName" -Value ""
Set-ItemProperty -Path "HKLM:\Software\Breakout Technologies\MonitorIT\Agent" -Name "ServerPort" -Value "443"

Write-Verbose "Stop logging" -Verbose
$EndDTM = (Get-Date)
Write-Verbose "Elapsed Time: $(($EndDTM-$StartDTM).TotalSeconds) Seconds" -Verbose
Write-Verbose "Elapsed Time: $(($EndDTM-$StartDTM).TotalMinutes) Minutes" -Verbose
Stop-Transcript
