function gcl {
    Param(
        [Switch]$d,
        [Parameter(Mandatory, ValueFromPipeline)]
        [String]$url
    )

    $option = $d ? '--depth 1' : ''
    iex "git clone $option --recurse-submodules $url"
}

function gr ([String]$hash) {
    git rebase -i $hash
}

function gpf () {
    git push -f
}

function yd ([String]$url) {
    youtube-dl -f bestvideo+bestaudio $url
}

function eol {
    Param
    (
        [ValidateSet("lf", "crlf")]
        [String]$seq = "lf"
    )

    $cmd = switch ($seq) {
        lf { "dos2unix" }
        crlf { "unix2dos" }
    }

    iex "
        ls -recurse -file -name |
        ? { ~\AppData\Local\Programs\Git\usr\bin\file.exe `$_ -Match 'text' } |
        % -Parallel { $cmd `$_ } -AsJob
    "
}

function pathValidate ([String]$path) {
    $path | ? { Test-Path $_ } | Resolve-Path
}

function k ([String[]]$process) {
    Get-Process $process | Stop-Process
}

function e {
    exit
}

Set-PSReadLineKeyHandler Tab MenuComplete

Import-Module "$PSScriptRoot\docker\docker.ps1"
Import-Module "$PSScriptRoot\completion\_fd.ps1"
Import-Module "$PSScriptRoot\completion\_rg.ps1"
Import-Module posh-git
Import-Module DockerCompletion

iex (&starship init powershell)
