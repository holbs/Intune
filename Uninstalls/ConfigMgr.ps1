#Region: Detection
Get-Service -Name "SMS Agent Host" -ErrorAction SilentlyContinue
#EndRegion
#Region: Uninstall
$Process = Start-Process -FilePath "$env:WINDIR\ccmsetup\ccmsetup.exe" -ArgumentList "/Uninstall" -PassThru
Wait-Process -Id $Process.Id
# Stop services for the Configuration Manager client and Configuration Manager setup if they still exist
@("ccmexec","SMS Agent Host","ccmsetup") | Foreach-Object {Get-Service -Name $_ -ErrorAction SilentlyContinue | Stop-Service -Force}
# Remove certificates related to Configuration Manager
Get-ChildItem -Path "Cert:\LocalMachine\SMS" | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
# Remove registry keys related to the Configuration Manager client
@("HKLM:\Software\Microsoft\SMS","HKLM:\Software\Microsoft\CCMSetup","HKLM:\Software\Microsoft\CCM","HKLM:\Software\Microsoft\SystemCertificates\SMS") | Foreach-Object {Remove-Item -Path $_ -Recurse -Force -ErrorAction SilentlyContinue}
# Remove Configuration Manager WMI namespaces
@("Root\Ccm","Root\Ccm\Policy","Root\Ccm\Policy\Machine","Root\Ccm\Policy\User") | Foreach-Object {Get-CimInstance -Namespace $_ -ClassName __Namespace -ErrorAction SilentlyContinue | Remove-CimInstance}
# Remove any remaining files
$Paths = @(
    "$env:WINDIR\CCM",
    "$env:WINDIR\ccmcache",
    "$env:WINDIR\ccmsetup",
    "$env:ProgramFiles\Microsoft Configuration Manager",
    "$env:WINDIR\smscfg.ini",
    "$env:WINDIR\Logs\CCM"
)
$Paths | Foreach-Object {Remove-Item -Path $_ -Recurse -Force -ErrorAction SilentlyContinue}
#EndRegion