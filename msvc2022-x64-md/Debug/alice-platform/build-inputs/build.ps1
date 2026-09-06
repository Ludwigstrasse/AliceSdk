[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$AliceThirdPartyRoot,

    [Parameter(Mandatory = $true)]
    [string]$BuildRoot,

    [string]$DownloadsRoot,

    [string]$VcpkgExecutablePath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

foreach ($strRequiredPath in @($AliceThirdPartyRoot, $BuildRoot)) {
    if (-not [System.IO.Path]::IsPathFullyQualified($strRequiredPath)) {
        throw "An absolute path is required: $strRequiredPath"
    }
}
if (-not [string]::IsNullOrWhiteSpace($DownloadsRoot) -and
    -not [System.IO.Path]::IsPathFullyQualified($DownloadsRoot)) {
    throw "An absolute downloads path is required: $DownloadsRoot"
}
if (-not [string]::IsNullOrWhiteSpace($VcpkgExecutablePath) -and
    -not [System.IO.Path]::IsPathFullyQualified($VcpkgExecutablePath)) {
    throw "An absolute vcpkg executable path is required: $VcpkgExecutablePath"
}

$strAliceThirdPartyRoot = [System.IO.Path]::GetFullPath($AliceThirdPartyRoot)
$strBuildRoot = [System.IO.Path]::GetFullPath($BuildRoot)
if ($strBuildRoot -match '\s') {
    throw "The isolated build path cannot contain whitespace: $strBuildRoot"
}
if ([string]::IsNullOrWhiteSpace($DownloadsRoot)) {
    $strDownloadsRoot = Join-Path $strBuildRoot 'downloads'
}
else {
    $strDownloadsRoot = [System.IO.Path]::GetFullPath($DownloadsRoot)
}
if ($strDownloadsRoot -match '\s') {
    throw "The downloads path cannot contain whitespace: $strDownloadsRoot"
}
foreach ($strWorkPath in @($strAliceThirdPartyRoot, $strBuildRoot, $strDownloadsRoot, $PSScriptRoot)) {
    if ([System.IO.Path]::GetPathRoot($strWorkPath) -ieq 'C:\') {
        throw "Dependency source and build paths cannot use the system drive: $strWorkPath"
    }
}

$strDirectorySeparator = [System.IO.Path]::DirectorySeparatorChar
$strBuildBoundary = $strBuildRoot.TrimEnd('\', '/') + $strDirectorySeparator
$strSourceBoundary = $strAliceThirdPartyRoot.TrimEnd('\', '/') + $strDirectorySeparator
$strInputBoundary = $PSScriptRoot.TrimEnd('\', '/') + $strDirectorySeparator
$strDownloadsBoundary = $strDownloadsRoot.TrimEnd('\', '/') + $strDirectorySeparator
if ($strBuildBoundary.StartsWith($strSourceBoundary, [System.StringComparison]::OrdinalIgnoreCase) -or
    $strSourceBoundary.StartsWith($strBuildBoundary, [System.StringComparison]::OrdinalIgnoreCase) -or
    $strBuildBoundary.StartsWith($strInputBoundary, [System.StringComparison]::OrdinalIgnoreCase) -or
    $strInputBoundary.StartsWith($strBuildBoundary, [System.StringComparison]::OrdinalIgnoreCase)) {
    throw 'The isolated build directory cannot contain, or be contained by, the source or build-input directory'
}
if ($strDownloadsBoundary.StartsWith($strSourceBoundary, [System.StringComparison]::OrdinalIgnoreCase) -or
    $strSourceBoundary.StartsWith($strDownloadsBoundary, [System.StringComparison]::OrdinalIgnoreCase) -or
    $strDownloadsBoundary.StartsWith($strInputBoundary, [System.StringComparison]::OrdinalIgnoreCase) -or
    $strInputBoundary.StartsWith($strDownloadsBoundary, [System.StringComparison]::OrdinalIgnoreCase)) {
    throw 'The downloads directory cannot contain, or be contained by, the source or build-input directory'
}

$strVcpkgRoot = Join-Path $strAliceThirdPartyRoot 'extern\vcpkg'
$strVcpkgPath = if ([string]::IsNullOrWhiteSpace($VcpkgExecutablePath)) {
    Join-Path $strVcpkgRoot 'vcpkg.exe'
}
else {
    [System.IO.Path]::GetFullPath($VcpkgExecutablePath)
}
if (-not (Test-Path -LiteralPath $strVcpkgPath -PathType Leaf)) {
    throw "A vcpkg executable built from the fixed vcpkg revision is unavailable: $strVcpkgPath"
}
if ([System.IO.Path]::GetPathRoot($strVcpkgPath) -ieq 'C:\') {
    throw "The vcpkg executable cannot use the system drive: $strVcpkgPath"
}

$strExpectedAliceThirdPartyRevision = '2539f2d1ebf3a34cfb9598ec4ad21d03b285c171'
$strExpectedVcpkgRevision = '15e5f3820f0370f1ba7150853762cec0688cd396'
$strAliceThirdPartyRevision = (& git -C $strAliceThirdPartyRoot rev-parse HEAD).Trim()
if ($LASTEXITCODE -ne 0 -or $strAliceThirdPartyRevision -cne $strExpectedAliceThirdPartyRevision) {
    throw "AliceThirdParty revision must be $strExpectedAliceThirdPartyRevision"
}
$strVcpkgRevision = (& git -C $strVcpkgRoot rev-parse HEAD).Trim()
if ($LASTEXITCODE -ne 0 -or $strVcpkgRevision -cne $strExpectedVcpkgRevision) {
    throw "vcpkg revision must be $strExpectedVcpkgRevision"
}
$strAliceThirdPartyChanges = (& git -C $strAliceThirdPartyRoot status --porcelain --untracked-files=all | Out-String).Trim()
if ($LASTEXITCODE -ne 0 -or -not [string]::IsNullOrEmpty($strAliceThirdPartyChanges)) {
    throw 'AliceThirdParty must be a clean checkout of the fixed revision'
}
$strVcpkgChanges = (& git -C $strVcpkgRoot status --porcelain --untracked-files=all | Out-String).Trim()
if ($LASTEXITCODE -ne 0 -or -not [string]::IsNullOrEmpty($strVcpkgChanges)) {
    throw 'vcpkg must be a clean checkout of the fixed revision'
}
$strVcpkgExecutableRoot = Split-Path -Parent $strVcpkgPath
$strVcpkgExecutableRevision = (& git -C $strVcpkgExecutableRoot rev-parse HEAD).Trim()
if ($LASTEXITCODE -ne 0 -or $strVcpkgExecutableRevision -cne $strExpectedVcpkgRevision) {
    throw "The vcpkg executable must come from revision $strExpectedVcpkgRevision"
}
$strVcpkgExecutableChanges = (& git -C $strVcpkgExecutableRoot status --porcelain --untracked-files=all | Out-String).Trim()
if ($LASTEXITCODE -ne 0 -or -not [string]::IsNullOrEmpty($strVcpkgExecutableChanges)) {
    throw 'The vcpkg executable checkout must be clean'
}

$strBuildTreesRoot = Join-Path $strBuildRoot 'buildtrees'
$strInstallRoot = Join-Path $strBuildRoot 'installed'
$strPackagesRoot = Join-Path $strBuildRoot 'packages'
$strTripletRoot = Join-Path $PSScriptRoot 'triplets'
$null = New-Item -ItemType Directory -Path $strBuildRoot -Force

$strPreviousCompilerOptions = [Environment]::GetEnvironmentVariable('_CL_', 'Process')
$strPreviousLinkerOptions = [Environment]::GetEnvironmentVariable('LINK', 'Process')
$strPreviousPreservedEnvironment = [Environment]::GetEnvironmentVariable('VCPKG_KEEP_ENV_VARS', 'Process')
$strPreviousVcpkgRoot = [Environment]::GetEnvironmentVariable('VCPKG_ROOT', 'Process')
try {
    [Environment]::SetEnvironmentVariable('_CL_', "/d1trimfile:$strBuildTreesRoot\", 'Process')
    [Environment]::SetEnvironmentVariable('LINK', '/Brepro /PDBALTPATH:%_PDB%', 'Process')
    [Environment]::SetEnvironmentVariable('VCPKG_KEEP_ENV_VARS', '_CL_;LINK', 'Process')
    [Environment]::SetEnvironmentVariable('VCPKG_ROOT', $strVcpkgRoot, 'Process')

    $vecVcpkgArgument = @(
        'install',
        "--vcpkg-root=$strVcpkgRoot",
        '--triplet', 'x64-windows-alice',
        "--overlay-triplets=$strTripletRoot",
        "--x-manifest-root=$PSScriptRoot",
        "--x-install-root=$strInstallRoot",
        "--x-buildtrees-root=$strBuildTreesRoot",
        "--x-packages-root=$strPackagesRoot",
        "--downloads-root=$strDownloadsRoot",
        '--binarysource=clear'
    )
    & $strVcpkgPath @vecVcpkgArgument
    if ($LASTEXITCODE -ne 0) {
        throw "vcpkg failed with exit code $LASTEXITCODE"
    }
}
finally {
    [Environment]::SetEnvironmentVariable('_CL_', $strPreviousCompilerOptions, 'Process')
    [Environment]::SetEnvironmentVariable('LINK', $strPreviousLinkerOptions, 'Process')
    [Environment]::SetEnvironmentVariable('VCPKG_KEEP_ENV_VARS', $strPreviousPreservedEnvironment, 'Process')
    [Environment]::SetEnvironmentVariable('VCPKG_ROOT', $strPreviousVcpkgRoot, 'Process')
}
