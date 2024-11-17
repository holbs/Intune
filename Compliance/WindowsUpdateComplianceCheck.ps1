Try {
    $ntoskrnl = Get-Item -Path "$env:WINDIR\System32\ntoskrnl.exe"
    $ntoskrnlLastWriteTime = [datetime]$ntoskrnl.LastWriteTime
    If ($ntoskrnlLastWriteTime -gt (Get-Date).AddDays(-90)) {
        $BooleanWindowsUpdateComplianceCheck = $true
    }
} Catch {
    $BooleanWindowsUpdateComplianceCheck = $false
}
@{WindowsUpdateComplianceCheck = $BooleanWindowsUpdateComplianceCheck} | ConvertTo-Json -Compress