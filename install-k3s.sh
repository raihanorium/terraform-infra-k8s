k3sup install --local \
    --user "${USER}" \
    --k3s-version v1.31.5+k3s1 \
    --k3s-extra-args '--disable=traefik --docker --write-kubeconfig-mode=644' \
    --local-path "${HOME}/.kube/config"