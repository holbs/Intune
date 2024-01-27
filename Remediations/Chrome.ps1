#Region: Detection
If (Test-Path -Path "$env:SystemDrive\Users\*\AppData\Local\Google\Chrome\Application") {
    Exit 1
} Else {
    Exit 0
}
#EndRegion
#Region: Remediation
Get-Item -Path "$env:SystemDrive\Users\*\AppData\Local\Google\Chrome\Application" | Remove-Item -Recurse -Force -Confirm:$false
#EndRegion
