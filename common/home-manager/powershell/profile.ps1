if (Get-InstalledModule -Name posh-git) {
    Import-Module posh-git
}
else {
    Write-Output "Installing prompt... (this may take a moment)"
    Set-PSRepository -name PSGallery -InstallationPolicy Trusted
    Install-Module posh-git -Scope CurrentUser -Force -Repository PSGallery
    Import-Module posh-git
}

$GitPromptSettings.DefaultPromptPrefix.ForegroundColor = [ConsoleColor]::Magenta
$GitPromptSettings.DefaultPromptPath.ForegroundColor = [ConsoleColor]::Orange

function global:PromptWriteErrorInfo() {
    if ($global:GitPromptValues.DollarQuestion) { return }

    if ($global:GitPromptValues.LastExitCode) {
        "`e[31m(" + $global:GitPromptValues.LastExitCode + ") `e[0m"
    }
    else {
        "`e[31m! `e[0m"
    }
}
