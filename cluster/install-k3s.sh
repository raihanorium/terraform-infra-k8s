# setup k3s
k3sup install --local \
    --user "${USER}" \
    --k3s-version v1.31.5+k3s1 \
    --k3s-extra-args '--disable=traefik --docker --write-kubeconfig-mode=644' \
    --local-path "${HOME}/.kube/config"

# Check if Homebrew is installed, and install it if not
if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Check if Helm is installed, and install it if not
if ! command -v helm &> /dev/null; then
    echo "Helm not found. Installing..."
    brew install helm
else
    echo "Helm is already installed."
fi

# install cert-manager
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install cert-manager --namespace cert-manager --create-namespace --version v1.17.1 jetstack/cert-manager --set installCRDs=true


echo "Helming now..."

# create issuer
kubectl apply -f - <<EOF
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: raihan.dk@gmail.com
    privateKeySecretRef:
      name: letsencrypt-prod
    solvers:
    - http01:
        ingress:
          class: nginx
EOF

# install ingress-nginx
helm upgrade --install ingress-nginx ingress-nginx \
    --namespace ingress-nginx --create-namespace \
    --repo https://kubernetes.github.io/ingress-nginx \
    --set controller.allowSnippetAnnotations=true \
    --set controller.enableAnnotationValidations=false \
    --version 4.11.3