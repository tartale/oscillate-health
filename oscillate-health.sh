#!/bin/bash

THIS_SCRIPT_DIR="$(cd $(dirname ${BASH_SOURCE}); pwd)"
INTERVAL=${INTERVAL:-"1200"}
DEBUG="${DEBUG:-false}"
if [ "${DEBUG}" == "true" ];
then
    SET_DEBUG="-x"
else
    SET_DEBUG="+x"
fi
set ${SET_DEBUG}

function restartPods {
  if [ $# -lt 2 ]; then
    echo "usage: ${0} <namespace-array> <deployment-array>"
    return 1
  fi

  namespaces=("${!1}")
  deployments=("${!2}")
  isRestartFailed=false
  for namespace in "${namespaces[@]}"; do
    for deployment in "${deployments[@]}"; do
      echo "restarting deployment/${deployment}.${namespace}"
      kubectl rollout restart deployment ${deployment} -n ${namespace} || isRestartFailed=true 
      kubectl rollout status deployment ${deployment} -n ${namespace} || isRestartFailed=true
    done
  done

  if [ "$isRestartFailed" = true ]; then
    echo "failed to restart all the pods"
    return 1
  fi
}

namespaces=("default")
deployments=("reviews-v1" "reviews-v2" "reviews-v3")
while true
do
    echo "--------------------------------------------------"
    date
    filepath="${THIS_SCRIPT_DIR}/ratings-five-percent-errors.yaml"
    echo "kubectl apply -f ${filepath}"
    kubectl apply -f "${filepath}"
    echo "waiting for ratings deployment to be available"
    sleep 3 && kubectl wait --for=condition=available deployment/ratings-v1
    restartPods namespaces[@] deployments[@]
    echo "waiting ${INTERVAL} seconds"
    sleep ${INTERVAL}
    
    echo "--------------------------------------------------"
    date
    filepath="${THIS_SCRIPT_DIR}/ratings-normal.yaml"
    echo "kubectl apply -f ${filepath}"
    kubectl apply -f "${filepath}"
    echo "waiting for ratings deployment to be available"
    sleep 3 && kubectl wait --for=condition=available deployment/ratings-v1
    restartPods namespaces[@] deployments[@]
done
