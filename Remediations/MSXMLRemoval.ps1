#Region: Detection
New-PSDrive -Name HKCR -PSProvider Registry -Root "HKEY_CLASSES_ROOT" | Out-Null
$FileNames = @(
    "msxml.dll",
    "msxml4.dll"
)
$CLSIDs = @(
    "{88d969c0-f192-11d4-a65f-0040963251e5}",
    "{88d969c4-f192-11d4-a65f-0040963251e5}",
    "{88d969c1-f192-11d4-a65f-0040963251e5}",
    "{88d969c9-f192-11d4-a65f-0040963251e5}",
    "{88d969d6-f192-11d4-a65f-0040963251e5}",
    "{88d969c8-f192-11d4-a65f-0040963251e5}",
    "{88d969ca-f192-11d4-a65f-0040963251e5}",
    "{7c6e29bc-8b8b-4c3d-859e-af6cd158be0f}",
    "{88d969c6-f192-11d4-a65f-0040963251e5}",
    "{88d969c5-f192-11d4-a65f-0040963251e5}",
    "{88d969c2-f192-11d4-a65f-0040963251e5}",
    "{88d969c3-f192-11d4-a65f-0040963251e5}"
)
$OSArch = [string](Get-CimInstance -Class Win32_Processor).AddressWidth
If ($OSArch -eq "64") {
    $FilePath = "$env:WINDIR\SysWOW64"
    $RegPaths = "HKCR:\WOW6432Node\CLSID", "HKLM:\SOFTWARE\WOW6432Node\Classes\CLSID"
} Else {
    $FilePath = "$env:WINDIR\System32"
    $RegPaths = "HKCR:\CLSID", "HKLM:\SOFTWARE\Classes\CLSID"
}
Foreach ($File in $FileNames) {
    If (Test-Path "$FilePath\$File") {
        Exit 1
    }
}
Foreach ($Path in $RegPaths) {
    Foreach ($ID in $CLSIDs) {
        If (Test-Path "$Path\$ID") {
            Exit 1
        }
    }
}
Exit 0
#EndRegion
#Region: Remediation
New-PSDrive -Name HKCR -PSProvider Registry -Root "HKEY_CLASSES_ROOT" | Out-Null
$FileNames = @(
    "msxml.dll",
    "msxml4.dll"
)
$CLSIDs = @(
    "{88d969c0-f192-11d4-a65f-0040963251e5}",
    "{88d969c4-f192-11d4-a65f-0040963251e5}",
    "{88d969c1-f192-11d4-a65f-0040963251e5}",
    "{88d969c9-f192-11d4-a65f-0040963251e5}",
    "{88d969d6-f192-11d4-a65f-0040963251e5}",
    "{88d969c8-f192-11d4-a65f-0040963251e5}",
    "{88d969ca-f192-11d4-a65f-0040963251e5}",
    "{7c6e29bc-8b8b-4c3d-859e-af6cd158be0f}",
    "{88d969c6-f192-11d4-a65f-0040963251e5}",
    "{88d969c5-f192-11d4-a65f-0040963251e5}",
    "{88d969c2-f192-11d4-a65f-0040963251e5}",
    "{88d969c3-f192-11d4-a65f-0040963251e5}"
)
$OSArch = [string](Get-CimInstance -Class Win32_Processor).AddressWidth
If ($OSArch -eq "64") {
    $FilePath = "$env:WINDIR\SysWOW64"
    $RegPaths = "HKCR:\WOW6432Node\CLSID", "HKLM:\SOFTWARE\WOW6432Node\Classes\CLSID"
} Else {
    $FilePath = "$env:WINDIR\System32"
    $RegPaths = "HKCR:\CLSID", "HKLM:\SOFTWARE\Classes\CLSID"
}
New-Item -Path "$env:SystemDrive\MSXML" -ItemType Directory | Out-Null
Foreach ($File in $FileNames) {
    If (Test-Path "$FilePath\$File") {
        Start-Process -WindowStyle hidden -Path "$env:WINDIR\System32\regsvr32.exe" -ArgumentList "/u /s $File" -Wait
        Move-Item -Path "$FilePath\$File" -Destination "$env:SystemDrive\MSXML\$File.bak" | Out-Null
    }
}
Foreach ($Path in $RegPaths) {
    Foreach ($ID in $CLSIDs) {
        If (Test-Path "$Path\$ID") {
            $ProgID = Get-ItemProperty -Path "$Path\$ID\ProgID" | Select-Object -ExpandProperty '(default)'
            Start-Process -WindowStyle hidden -Path "$env:WINDIR\System32\reg.exe" -ArgumentList "EXPORT $($Path.Replace(':',''))\$ID $env:SystemDrive\MSXML\$ProgID.reg" -Wait
            Remove-Item -Path "$Path\$ID" -Force -Recurse -Confirm:$false
        }
    }
}
#EndRegion
