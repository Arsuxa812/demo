# Выкладка демо-сайтов с Диска на GitHub Pages: https://arsuxa812.github.io/demo/
# Запуск: powershell -File C:\Users\arsbu\Projects\demo-sites\publish.ps1
$src = "G:\Мой диск\Местный бизнес ЕКБ\Демо"
$dst = $PSScriptRoot
robocopy $src $dst /E /XD "_старые версии" "_долгий ящик" ".git" /XF "*.bak" "index.v1.html" "publish.ps1" /NFL /NDL /NJH /NJS | Out-Null
$meta  = '<meta name="robots" content="noindex,nofollow">'
$badge = '<div style="position:fixed;left:10px;bottom:10px;z-index:2147483647;background:rgba(0,0,0,.72);color:#fff;font:12px/1.2 system-ui,sans-serif;padding:6px 10px;border-radius:999px;pointer-events:none">Демо-версия · не официальный сайт</div>'
Get-ChildItem $dst -Recurse -Filter *.html | Where-Object { $_.FullName -notmatch '\\\.git\\' } | ForEach-Object {
  $t = [IO.File]::ReadAllText($_.FullName, [Text.Encoding]::UTF8)
  if ($t -notmatch 'noindex') { $t = $t -replace '(?i)<head([^>]*)>', "<head`$1>`n$meta" }
  if ($_.Directory.FullName -ne $dst -and $t -notmatch 'Демо-версия · не официальный') { $t = $t -replace '(?i)</body>', "$badge`n</body>" }
  [IO.File]::WriteAllText($_.FullName, $t, (New-Object Text.UTF8Encoding $false))
}
Set-Location $dst
git add -A
git -c core.quotepath=false commit -q -m "Обновление демо-сайтов`n`nCo-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
git push -q
"Готово: https://arsuxa812.github.io/demo/ (обновится через ~1 мин)"
