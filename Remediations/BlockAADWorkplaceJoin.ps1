#Region: Detection
Try {
    $BlockAADWorkplaceJoin = Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WorkplaceJoin" -ErrorAction Stop
    If ($BlockAADWorkplaceJoin.BlockAADWorkplaceJoin -eq 1) {
        Exit 0
    } Else {
        Exit 1
    }
} Catch {
    Exit 1
}
#EndRegion
#Region: Remediation
New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WorkplaceJoin' -Force | Out-Null
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WorkplaceJoin' -Name 'BlockAADWorkplaceJoin' -Value '1' -Type DWord -Force | Out-Null
#EndRegion
