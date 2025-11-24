# Löscht alle lokalen Branches, die bereits in einem PR gemerged wurden

$defaultBranch = git symbolic-ref refs/remotes/origin/HEAD 2>$null | ForEach-Object { $_ -replace 'refs/remotes/origin/', '' }

if (-not $defaultBranch) {
    $defaultBranch = "main"
}

Write-Host "Default Branch: $defaultBranch"

$currentBranch = git branch --show-current

git fetch --prune

$mergedBranches = git branch --merged $defaultBranch | ForEach-Object { $_.Trim() } | Where-Object { $_ -notmatch '^\*' -and $_ -ne $defaultBranch -and $_ -ne $currentBranch }

if ($mergedBranches.Count -eq 0) {
    Write-Host "Nix do, all Branches sin noch am Schaffe."
    exit 0
}

Write-Host "`nDiese Branches wore als gemerged unn künne fott:"
$mergedBranches | ForEach-Object { Write-Host "  - $_" }

$confirmation = Read-Host "`nWillste die wirklich fottschmieße? (j/n)"

if ($confirmation -eq 'j' -or $confirmation -eq 'J') {
    $mergedBranches | ForEach-Object {
        Write-Host "Schmeiße fott: $_"
        git branch -d $_
    }
    Write-Host "`nFäädisch!"
} else {
    Write-Host "Hasse jenau jemaat - losse mer dran."
}
