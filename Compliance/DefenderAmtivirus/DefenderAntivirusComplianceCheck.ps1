Try {
    $WinDefend = Get-Service -Name WinDefend -ErrorAction Stop
    If ($WinDefend.Status -eq "Running") {
        $DefenderAntivirusComplianceCheck = $true
    }
} Catch {
    $DefenderAntivirusComplianceCheck = $false
}
@{DefenderAntivirusComplianceCheck = $DefenderAntivirusComplianceCheck} | ConvertTo-Json -Compress