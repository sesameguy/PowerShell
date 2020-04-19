function devtool ([String]$src) {
    # -v C:/prj:/prj
    $bind = pathValidate $src | mountFolder "/prj"

    iex "
        docker create ``
            --name devtool ``
            $bind ``
            -v devtool:/root/.vscode-server ``
            --tmpfs /tmp ``
            -i ``
            tmpac/devtool
    "
}

function heimdall {
    docker create `
        --name heimdall `
        -e PUID=1000 `
        -e PGID=1000 `
        -e TZ=Asia/Hong_Kong `
        -P `
        -v heimdall:/config `
        linuxserver/heimdall
}

function rutorrent ([String]$src = "c:/rutorrent", [switch]$create) {
    $container = $MyInvocation.InvocationName
    $entryPort = "80/tcp"

    if ($create) {
        $bind = pathValidate $src | mountFolder "/downloads"

        iex "
            docker run ``
                --name $container ``
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
    else {
        if (docker ps -q -f "name=$container") {
            explorer "http://localhost:$((docker port $container | rg -w $entryPort).split(":")[-1])/"
        }
        else {
            "$container does not exist"
        }
    }
}

function portainer ([switch]$create) {
    $container = $MyInvocation.InvocationName
    $entryPort = "9000/tcp"

    if ($create) {
        docker run `
            --name $container `
            -P `
            -v /var/run/docker.sock:/var/run/docker.sock `
            -v portainer:/data `
            --restart always `
            -d `
            portainer/portainer
    }
    else {
        if (docker ps -q -f "name=$container") {
            explorer "http://localhost:$((docker port $container | rg -w $entryPort).split(":")[-1])/"
        }
        else {
            "$container does not exist"
        }
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
