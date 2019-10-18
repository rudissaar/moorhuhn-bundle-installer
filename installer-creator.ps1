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

$CompressInstallerIfPossible = 1

$7zipFallback = ''
$BinaryCreatorFallback = ''
$UpxFallback = ''

$global:InstallerName = "${PSScriptRoot}\dist\moorhuhn-bundle-installer.exe"

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


Function Get-7zip
{
    If (Get-Command '7z.exe' -ErrorAction SilentlyContinue) {
        Return (Get-Command '7z.exe' | Select -ExpandProperty Source)
    } Else {
        If (-Not ([string]::IsNullOrEmpty($7zipFallback))) {
            Return $7zipFallback
        }
    }

    Return 1
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

Function Get-Upx
{
    If (Get-Command 'upx.exe' -ErrorAction SilentlyContinue) {
        Return (Get-Command 'upx.exe' | Select -ExpandProperty Source)
    } Else {
        If (-Not ([string]::IsNullOrEmpty($UpxFallback))) {
            Return $UpxFallback
        } Else {
            If ($CompressInstallerIfPossible) {
                Write-Output "> Unable to find upx.exe from your environment's PATH variable."
                echo '> Compressing the installer will be skipped.'
            }
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
