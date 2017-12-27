<#
.SYNOPSIS
This is a Powershell script create and test the solution template contained in this repository.
REQUIRES: https://github.com/nightroman/Invoke-Build

.DESCRIPTION
This Powershell script will create a temporary folder, optionally install the template if supplied with -InstallTemplates, copy the necessary files in, and run `dotnet new `

.PARAMETER name
The descriptive name of your solution. Defaults to current directory name. Default: AliG
.PARAMETER ViewEngine
Tells the script which view engine to use. Giraffe, Razor, DotLiquid, None. Default: Giraffe
.PARAMETER IncludeTests
Tells the script to include creation of a web test project. Default: false
.PARAMETER UsePaket
Tells the script to Paket package management instead of Nuget. Default: false
.PARAMETER InstallTemplates
Tells the script to install the template before running. Default: false
.PARAMETER Keep
Tells the script to keep the generated files even if fails. Default: false
#>

Param(
    [Parameter(Mandatory=$false)]
    [string]$name = "AliG",
    [string]$ViewEngine = "Giraffe",
    [switch]$IncludeTests=$false,
    [switch]$UsePaket=$false,
    [switch]$InstallTemplates=$false,
    [switch]$Keep=$false
)

function New-TemporaryDirectoryPath {
    $parent = [System.IO.Path]::GetTempPath()
    $name = [System.IO.Path]::GetRandomFileName()
    $name = "giraffe_" + $name
    $path = Join-Path $parent $name
    return $path
}

$temp = New-TemporaryDirectoryPath
$originaldir = Split-Path $MyInvocation.MyCommand.Path

task Install-Templates -If ($InstallTemplates) {
    "Installing template..."
    exec { & dotnet new -i ./src/content/ }
}

task New-Solution Install-Templates, {
    exec {
        "Creating project..."
        # create new temp directory
        New-Item -ItemType Directory -Path $temp
        $temp
    
        # generate template
        cd $temp
        $cmd = "dotnet new giraffe -n $name -V $ViewEngine"
        if($UsePaket){
            $cmd = $cmd + " -U"
        }
        if($IncludeTests){
            $cmd = $cmd + " -I"
        }
        
        Invoke-Expression $cmd
        cd $originaldir
        
        # open explorer
        # ii $temp
    }
}

task Start-Build {
    exec {
        "Build and test..."
        &cd $temp
        &"$temp\build.bat"
    }
}

task Remove-Temp -If (-Not $Keep) {
    "Cleaning up..."
    Remove-Item $temp -Recurse
}

task Open-Temp -If ($Keep) {
    ii $temp
}

task Get-Temp {
    "Go to $temp"
    &cd $temp
}

task Get-Original {
    "Go to $originaldir"
    &cd $originaldir
}

task . New-Solution, Start-Build, Remove-Temp, Open-Temp, Get-Original