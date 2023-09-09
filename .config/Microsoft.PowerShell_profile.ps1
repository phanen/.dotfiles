Invoke-Expression (& { (zoxide init powershell | Out-String) })
Set-Alias v nvim
Set-Alias vi nvim
Import-Module PSReadLine
Set-PSReadLineOption -EditMode Emacs
