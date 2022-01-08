powershell Invoke-WebRequest https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -O Microsoft.VCLibs.x64.14.00.Desktop.appx
Add-AppPackage -path Microsoft.VCLibs.x64.14.00.Desktop.appx
Invoke-WebRequest https://git.io/J9shz -O Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
Add-AppPackage -path Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
