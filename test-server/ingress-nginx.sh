helm upgrade --install ingress-nginx ingress-nginx \
    --namespace ingress-nginx --create-namespace \
    --repo https://kubernetes.github.io/ingress-nginx \
    --set controller.allowSnippetAnnotations=true \
    --set controller.enableAnnotationValidations=false \
    --version 4.11.3