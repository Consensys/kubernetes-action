#!/bin/bash -l

echo ${KUBE_CONFIG_DATA} | base64 -d > kubeconfig
export KUBECONFIG=kubeconfig
command=$1
if [[ $command == *"kubectl"* ]]; 
then
  result="$($command)"
else
  result="$(kubectl $command)"
fi
status=$?
echo ::set-output name=result::$result
echo "$result"
if [[ $status -eq 0 ]]; then exit 0; else exit 1; fi
