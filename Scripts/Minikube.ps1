function mks {
    minikube start --driver hyperv --container-runtime containerd --cpus max --mount --mount-string C:\Users\ssg\Desktop:/minikube-host
}

function kc {
    minikube kubectl -- $args
}
