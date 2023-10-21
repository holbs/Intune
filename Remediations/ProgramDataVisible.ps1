#Region: Detect
Try {
    $ProgramData = Get-Item $env:ProgramData -Force
    If ($ProgramData.Attributes -like "*Hidden*") {
        Exit 1
    } Else {
        Exit 0
    }
} Catch {
    Exit 1
}
#EndRegion
#Region: Remediate
$Folder = Get-Item $env:ProgramData -Force 
$Folder.Attributes = $Folder.Attributes -band -bnot [System.IO.FileAttributes]::Hidden
#EndRegion
