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

function gca {
    git commit --amend
}

function gpf {
    git push -f
}
