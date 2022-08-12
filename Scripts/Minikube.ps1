function mk {
    switch ($args)
    {
        "sa" {
            $status = 0
            switch -wildcard (mk status)
            {
                '*Stopped*' {$status = 1}
                '*not found*' {$status = 2}
            }

            if ($status -gt 0)
            {
                if ($status -gt 1)
                {
                    $desktop = rvpa ~\Desktop
                    $args = "start --container-runtime cri-o --cpus max --memory 2g --mount --mount-string ${desktop}:/desktop"
                }
                iex "gsudo minikube $args"
            }
        }
        "sp" {
            gsudo spvm minikube
        }
        "del" {
            mk stop
            gsudo Remove-VM minikube
            minikube delete --all
        }
        Default {
            gsudo minikube $args
        }
    }
}

function kc {
    minikube kubectl -- $args
}