#Region: Detection
Try {
    $RightClick = Get-ItemProperty -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" -ErrorAction Stop
    If ($RightClick.'(default)' -eq "") {
        Exit 0
    } Else {
        Exit 1
    }
} Catch {
    Exit 1
}
#EndRegion
#Region: Remediation
New-Item -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}"
New-Item -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32"
New-ItemProperty -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" -Name "(default)" -Value "" -Force
Stop-Process -ProcessName "Explorer"
#EndRegion
