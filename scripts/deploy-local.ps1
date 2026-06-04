# Deploy local a MonsterASP.NET via WebDeploy
# Uso: .\scripts\deploy-local.ps1
# Requiere: Web Deploy 3 y variables de entorno (no guardar contraseña en el repo)

param(
    [string]$PublishDir = "$PSScriptRoot\..\publish",
    [string]$Site = $env:WEBDEPLOY_SITE,
    [string]$Server = $env:WEBDEPLOY_SERVER,
    [string]$User = $env:WEBDEPLOY_USER,
    [string]$Password = $env:WEBDEPLOY_PASSWORD
)

$msdeploy = "${env:ProgramFiles(x86)}\IIS\Microsoft Web Deploy V3\msdeploy.exe"
if (-not (Test-Path $msdeploy)) {
    throw "Web Deploy no instalado. Instala IIS Web Deploy 3."
}

if (-not $Site) { $Site = "site72384" }
if (-not $Server) { $Server = "https://site72384.siteasp.net:8172" }
if (-not $User) { $User = "site72384" }
if (-not $Password) {
    throw "Define WEBDEPLOY_PASSWORD (y opcionalmente WEBDEPLOY_SITE, WEBDEPLOY_SERVER, WEBDEPLOY_USER)"
}

$projectRoot = Resolve-Path "$PSScriptRoot\.."
Set-Location $projectRoot

Write-Host "Publishing..."
dotnet publish HackerRank1/HackerRank1.csproj -c Release -o ./publish --runtime win-x86 --self-contained false
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$publishPath = Resolve-Path "./publish"
$computerName = "$Server/MsDeploy.axd?site=$Site"

Write-Host "Deploying to $Site..."
& $msdeploy -verb:sync -allowUntrusted `
    -source:contentPath="$publishPath" `
    -dest:contentPath="$Site",computerName="$computerName",username="$User",password="$Password",AuthType='Basic' `
    -enableRule:DoNotDeleteRule

if ($LASTEXITCODE -eq 0) {
    Write-Host "Deploy OK: https://$Site.siteasp.net"
}
