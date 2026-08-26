#Requires -Version 5.1
<#
.SYNOPSIS
    Bootstraps the AI Layer workflow template into an existing project.
.PARAMETER TargetPath
    Path to the target project's repository root.
#>
param(
    [Parameter(Mandatory = $true)]
    [string]$TargetPath
)

$ErrorActionPreference = 'Stop'
$sourceRoot = Split-Path -Parent $PSScriptRoot

if (-not (Test-Path $TargetPath)) {
    throw "Target path '$TargetPath' does not exist."
}
$TargetPath = (Resolve-Path $TargetPath).Path

# Paths (relative to source root) that stay in the template and are never copied.
$excludedRelPaths = @(
    '.git',
    'README.md',
    'scripts\init.ps1',
    'scripts\init.sh'
)

function Test-Excluded([string]$relativePath) {
    foreach ($excluded in $excludedRelPaths) {
        if ($relativePath -eq $excluded -or $relativePath.StartsWith("$excluded\")) {
            return $true
        }
    }
    return $false
}

$files = Get-ChildItem -Path $sourceRoot -Recurse -File
$copied = 0
$skipped = 0

foreach ($file in $files) {
    $relativePath = $file.FullName.Substring($sourceRoot.Length + 1)
    if (Test-Excluded $relativePath) { continue }

    $destination = Join-Path $TargetPath $relativePath
    $destinationDir = Split-Path -Parent $destination
    if (-not (Test-Path $destinationDir)) {
        New-Item -ItemType Directory -Path $destinationDir -Force | Out-Null
    }

    if (Test-Path $destination) {
        $answer = Read-Host "File exists: $relativePath - overwrite? (y/N)"
        if ($answer -ne 'y') {
            $skipped++
            continue
        }
    }

    Copy-Item -Path $file.FullName -Destination $destination -Force
    Write-Host "Copied $relativePath"
    $copied++
}

Write-Host ""
Write-Host "AI Layer template installed into $TargetPath ($copied copied, $skipped skipped)"
Write-Host "Next steps:"
Write-Host "  1. git init the target if it isn't a repo - the test gate and reviewer need 'git diff'."
Write-Host "  2. Fill in .ai/config/commands.sh (AI_LAYER_TEST_CMD, AI_LAYER_FORMAT_CMD); placeholders leave the hooks inert."
Write-Host "  3. Fill in placeholders in AGENTS.md (stack, entry points, conventions)."
Write-Host "  4. Set the real model IDs at the top of scripts/gen-agents.sh, then run: bash scripts/gen-agents.sh"
Write-Host "  5. Clone .ai/agents/implementer.md per repo area, fill each ## Scope, and regenerate."
Write-Host "  6. Fill in .ai/memory/architecture.md and .ai/memory/repo.md."
Write-Host "  7. Point the applyTo globs in .github/instructions/* at your real directories."
Write-Host "  8. Make sure bash (e.g. Git Bash) is on PATH, then verify: bash scripts/hooks/test-hooks.sh"
Write-Host "  9. Trust the workspace so agents/skills/hooks are loaded."
