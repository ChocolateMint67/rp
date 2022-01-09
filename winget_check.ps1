$software = "Microsoft.DesktopAppInstaller";
$installed = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where { $_.DisplayName -eq $software }) -ne $null

If(-Not $installed) {
	Write-Host "'$software' nu este instalat, il vom instala acum...";
        cd $env:TEMP
	Invoke-WebRequest https://git.io/J9shP -O winget_downloader.ps1
	powershell -noprofile -executionpolicy bypass -file winget_downloader.ps1	
} else {
	Write-Host "'$software' este instalat, continuam..."
}
