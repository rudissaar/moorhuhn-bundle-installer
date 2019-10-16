<#
 .SYNOPSIS

 .DESCRIPTION

 .REQUIREMENTS
  - Windows PowerShell 4.0 or higher
  - Qt Installer Framework 3.0 or higher
  - 7-Zip
  - UPX (Optional)
#>

Set-StrictMode -Version 3

$global:InstallerName = "${PSScriptRoot}\dist\moorhuhn-bundle-installer.exe"

$BinaryCreatorFallback = ''


Function Main
{
    If ((Get-BinaryCreator) -Eq 1) {
        Write-Output "> Unable to find binarycreator.exe from your environment's PATH variable."
        Write-Output '> Aborting.'
        Exit(1)
    }

    Write-Output "> BinaryCreator binary found at: '$(Get-BinaryCreator)'"

    Build-Installer
}

Function Get-BinaryCreator
{
    If (Get-Command 'binarycreator.exe' -ErrorAction SilentlyContinue) {
        Return (Get-Command 'binarycreator.exe' | Select -ExpandProperty Source)
    } Else {
        If (-Not ([string]::IsNullOrEmpty($BinaryCreatorFallback))) {
            Return $BinaryCreatorFallback
        }
    }

    Return 1
}

Function Build-Installer
{
    Write-Output "> Creating installer."

    $Params = @(
        '--offline-only',
        '-c', 'config/config.xml',
        '-p', 'packages',
        "${InstallerName}"
    )

    & (Get-BinaryCreator) $Params
}

. Main
