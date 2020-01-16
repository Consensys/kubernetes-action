#!/bin/sh -l

echo ${KUBE_CONFIG_DATA} | base64 -d > kubeconfig
export KUBECONFIG=kubeconfig
result=$(kubectl $1)
echo ::set-output name=result::$result
