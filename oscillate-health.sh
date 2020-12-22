#!/bin/bash

THIS_SCRIPT_DIR="$(cd $(dirname ${BASH_SOURCE}); pwd)"
INTERVAL=${INTERVAL:-"1200"}

while true
do
    echo "--------------------------------------------------"
    date
    filepath="${THIS_SCRIPT_DIR}/ratings-five-percent-errors.yaml"
    echo "kubectl apply -f ${filepath}"
    kubectl apply -f "${filepath}"
    echo "waiting for ratings deployment to be available"
    sleep 3 && kubectl wait --for=condition=available deployment/ratings-v1
    echo "restarting reviews-v3"
    kubectl delete pods -l 'app=reviews,version=v3'
    echo "waiting ${INTERVAL} seconds"
    sleep ${INTERVAL}
    
    echo "--------------------------------------------------"
    date
    filepath="${THIS_SCRIPT_DIR}/ratings-normal.yaml"
    echo "kubectl apply -f ${filepath}"
    kubectl apply -f "${filepath}"
    echo "waiting for ratings deployment to be available"
    sleep 3 && kubectl wait --for=condition=available deployment/ratings-v1
    echo "restarting reviews-v3"
    kubectl delete pods -l 'app=reviews,version=v3'
    echo "waiting ${INTERVAL} seconds"
    sleep ${INTERVAL}
done
