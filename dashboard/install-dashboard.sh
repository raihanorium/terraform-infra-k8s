helm upgrade --install ingress-nginx ingress-nginx \
    --namespace ingress-nginx --create-namespace \
    --repo https://kubernetes.github.io/ingress-nginx \
    --set controller.allowSnippetAnnotations=true \
    --set controller.enableAnnotationValidations=false \
    --version 4.11.3

# install dashboard
kubectl create namespace kubernetes-dashboard
helm upgrade --install kubernetes-dashboard kubernetes-dashboard \
    --repo https://kubernetes.github.io/dashboard/ \
    --version 7.10.4 \
    --namespace kubernetes-dashboard --create-namespace \
    --set "extraArgs={'--enable-skip-login','--enable-insecure-login'},protocolHttp=true,metricsScraper.enabled=true"
  kubectl wait pods -n kubernetes-dashboard -l app.kubernetes.io/name=kubernetes-dashboard --for condition=Ready --timeout=180s >/dev/null 2>&1
  kubectl apply -f "dashboard_rbac.yaml"

  # setup kubernetes dashboard ingress
#  kubectl -n kubernetes-dashboard create secret tls dashboard-tls --key="${DIR}/../config/certs/ingress/ideascale.me/cert.key" --cert="${DIR}/../config/certs/ingress/ideascale.me/cert.pem"

  # create dashboard ingress
  kubectl apply -f "dashboard_ingress.yaml"

  if [[ "${DEPLOY_ISTIO}" == 'true' ]]; then
    configure_namespace_for_istio kubernetes-dashboard
  fi