#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="monitoring"

kubectl create namespace "${NAMESPACE}" --dry-run=client -o yaml | kubectl apply -f -

# Add Helm repos
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# Install Loki
helm upgrade --install loki grafana/loki \
  -n "${NAMESPACE}" \
  -f helm/loki-values.yaml

# Install Promtail
helm upgrade --install promtail grafana/promtail \
  -n "${NAMESPACE}" \
  -f helm/promtail-values.yaml

# Install Grafana
helm upgrade --install grafana grafana/grafana \
  -n "${NAMESPACE}" \
  -f helm/grafana-values.yaml

echo "Installed observability stack into namespace: ${NAMESPACE}"
echo "Next: kubectl -n ${NAMESPACE} port-forward svc/grafana 3000:80"
