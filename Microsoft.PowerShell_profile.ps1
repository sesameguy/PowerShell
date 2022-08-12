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

function wh ([String]$exe) {
    gcm $exe | select Source
}

function en64 ([String]$utf8) {
    [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($utf8))
}

function de64 ([String]$base64) {
    [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($base64))
}

function Set-Hosts {
    code C:\Windows\System32\drivers\etc
}

function dn ([String]$uri, [String]$loc = '.') {
    $folder = rvpa $loc
    $file = Split-Path $uri -Leaf
    iwr $uri -OutFile (Join-Path $folder $file)
}

Set-PSReadLineKeyHandler Ctrl+d DeleteCharOrExit
Set-PSReadLineKeyHandler Tab MenuComplete

ls $PSScriptRoot\Completion, $PSScriptRoot\Scripts -Filter *.ps1 -Recurse | Import-Module
Import-Module DockerCompletion
Import-Module posh-git
Import-Module PSFzf

iex (&starship init powershell)
iex (& {
        $hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
        (zoxide init --hook $hook powershell | Out-String)
    })