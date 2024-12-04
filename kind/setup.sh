#!/usr/bin/env bash

set -euo pipefail

# Color variables
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
blue='\033[0;34m'
magenta='\033[0;35m'
cyan='\033[0;36m'
# Clear the color after that
clear='\033[0m'

kind create cluster --config kind-config.yaml --wait 1m
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=90s &>/dev/null
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
helm upgrade -i kubernetes-dashboard \
  kubernetes-dashboard/kubernetes-dashboard \
  --create-namespace -n kubernetes-dashboard
kubectl -n kubernetes-dashboard wait --for condition=ready pod -l app.kubernetes.io/part-of=kubernetes-dashboard &>/dev/null
kubectl apply -f dashboard.yaml
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
kubectl patch -n kube-system deployment metrics-server --type=json \
  -p '[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"}]'
