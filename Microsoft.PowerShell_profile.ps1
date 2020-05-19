function gup {
    git pull -r
}

function gcl ([String]$url) {
    git clone --depth 1 --recurse-submodules $url
}

function de {
    drone exec
}

function yd {
    Param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [String]$url
    )

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
# Import-Module powershell-yaml
. "~\Documents\PowerShell\docker\docker.ps1"
. "~\Documents\PowerShell\completion\_fd.ps1"
. "~\Documents\PowerShell\completion\_rg.ps1"

iex (&starship init powershell)
