function pathValidate ([String]$path) {
    $path | ? { Test-Path $_ } | Resolve-Path
}

# docker bind mount
function mountFolder {
    Param
    (
        [String]$dst,

        [Parameter(ValueFromPipeline)]
        [String]$src
    )

    $src | ? { $_ } | % { "-v $($_ -replace '\\', '/'):$dst" }
}

function lara () {
    sl "~/laradock"
    docker-compose down
    git pull -r
    docker-compose up -d nginx mariadb
}

function dcr {
    sl "~/laradock"
    docker-compose exec workspace bash
}

function nd ([String]$src = "~\node", [Int]$port) {
    $bind = pathValidate $src | mountFolder "/prj"
    $map = $port | ? { $_ -gt 0 -and ($_ -lt 65535) } | % { "-p $_" } # 0 < port < 65535

    iex "
        docker run ``
            -e TZ=Asia/Hong_Kong ``
            -P ``
            $map ``
            $bind ``
            -v node:/root/.vscode-server/extensions ``
            --tmpfs /root/.cache ``
            --tmpfs /tmp ``
            -di ``
            tmpac/node
    "
}

function heimdall {
    docker run `
        --name heimdall `
        -e PUID=1000 `
        -e PGID=1000 `
        -e TZ=Asia/Hong_Kong `
        -P `
        -v heimdall:/config `
        linuxserver/heimdall
}

function rutorrent ([String]$src = "d:/rutorrent", [switch]$create) {
    $container = $MyInvocation.InvocationName
    $entryPort = "80/tcp"

    if ($create) {
        $bind = pathValidate $src | mountFolder "/downloads"

        iex "
            docker run ``
                --name $container ``
                -e PUID=1000 ``
                -e PGID=1000 ``
                -e TZ=Asia/Hong_Kong ``
                -p 80 ``
                -p 5000 ``
                -p 51413 ``
                -p 6881/udp ``
                $bind ``
                --restart always ``
                -di ``
                linuxserver/rutorrent
        "
    }

    if (docker ps -q -f "name=$container") {
        explorer "http://localhost:$((docker port $container | rg -w $entryPort).split(":")[-1])/"
    }
    else {
        "$container does not exist"
    }
}

function portainer ([switch]$create) {
    $container = $MyInvocation.InvocationName
    $entryPort = "9000/tcp"

    if ($create) {
        docker run `
            --name $container `
            -e TZ=Asia/Hong_Kong `
            -P `
            -v /var/run/docker.sock:/var/run/docker.sock `
            -v portainer:/data `
            --restart always `
            -d `
            portainer/portainer
    }

    if (docker ps -q -f "name=$container") {
        explorer "http://localhost:$((docker port $container | rg -w $entryPort).split(":")[-1])/"
    }
    else {
        "$container does not exist"
    }
}

function watchtower {
    docker run `
        --name watchtower `
        -v /var/run/docker.sock:/var/run/docker.sock `
        --restart always `
        -d `
        containrrr/watchtower
}

function mitm {
    docker run --rm -it -v $Env:USERPROFILE\Desktop\.mitmproxy:/home/mitmproxy/.mitmproxy -p 8080:8080 -p 8081:8081 mitmproxy/mitmproxy mitmweb --web-host 0.0.0.0
}
