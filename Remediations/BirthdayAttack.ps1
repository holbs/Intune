#Region: Detection
Try {
    $TripleDES168 = Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\Triple DES 168' -ErrorAction Stop
    If ($TripleDES168.Enabled -ne 0) {
        Exit 1
    }
} Catch {
    Exit 1
}
Exit 0
#EndRegion
#Region: Remediation
New-Item -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\Triple DES 168'
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\Triple DES 168' -Name 'Enabled' -Value '0' -Type DWord -Force
#EndRegion
