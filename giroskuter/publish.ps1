<#
.SYNOPSIS
    Публикация проекта My-Giro на GitHub: отправляет все ветки в удалённый репозиторий.

.EXAMPLE
    .\publish.ps1 -Repo "https://github.com/username/my-giro.git"

.EXAMPLE
    .\publish.ps1 -Repo "https://github.com/username/my-giro.git" -Token $env:GITHUB_TOKEN
#>
param(
    [Parameter(Mandatory = $true)]
    [string]$Repo,

    # необязательный Personal Access Token: если не указан, git спросит сам
    [string]$Token,

    [string[]]$Branches = @("main", "design", "layout", "gh-pages")
)

$ErrorActionPreference = "Stop"

# 1. Проверяем, что скрипт запущен в корне git-репозитория
if (-not (Test-Path ".git")) {
    Write-Host "Ошибка: запустите скрипт в папке проекта (там, где лежит .git)." -ForegroundColor Red
    exit 1
}

# 2. Настраиваем адрес удалённого репозитория
if ($Token) {
    $clean = $Repo -replace "https://", ""
    $RepoWithToken = "https://$Token@$clean"
    git remote remove origin 2>$null
    git remote add origin $RepoWithToken
    Write-Host "Remote origin добавлен (с токеном, в историю не попадёт)." -ForegroundColor Green
}
else {
    $existing = git remote 2>$null
    if ($existing -contains "origin") {
        git remote set-url origin $Repo
        Write-Host "Remote origin обновлён: $Repo" -ForegroundColor Green
    }
    else {
        git remote add origin $Repo
        Write-Host "Remote origin добавлен: $Repo" -ForegroundColor Green
    }
}

# 3. Отправляем ветки
foreach ($branch in $Branches) {
    if (git show-ref --verify --quiet "refs/heads/$branch") {
        Write-Host "-> push $branch" -ForegroundColor Cyan
        git push -u origin $branch
    }
    else {
        Write-Host "!! ветка $branch не найдена, пропускаем" -ForegroundColor Yellow
    }
}

# 4. Подсказка про GitHub Pages
$user = ($Repo -replace "https://github.com/", "") -replace "/.*", ""
$name = ($Repo -replace "\.git$", "") -replace ".*/", ""

Write-Host ""
Write-Host "Готово. Осталось включить сайт:" -ForegroundColor Green
Write-Host "  1) https://github.com/$user/$name/settings/pages"
Write-Host "  2) Source: Deploy from a branch -> Branch: gh-pages / (root) -> Save"
Write-Host ""
Write-Host "Ссылки для сдачи:"
Write-Host "  репозиторий: https://github.com/$user/$name"
Write-Host "  сайт:        https://$user.github.io/$name/"
