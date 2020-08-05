#!/bin/bash

THIS_SCRIPT_DIR="$(cd $(dirname ${BASH_SOURCE}); pwd)"

counter=0
while true
do
    echo "--------------------------------------------------"
    date
    echo "five percent errors:"
    /usr/bin/kubectl apply -f ${THIS_SCRIPT_DIR}/ratings-five-percent-errors.yaml
    echo "waiting ${INTERVAL} seconds"
    sleep ${INTERVAL}
    echo "--------------------------------------------------"
    date
    echo "no errors:"
    /usr/bin/kubectl apply -f ${THIS_SCRIPT_DIR}/ratings-normal.yaml
    counter=$((counter+1))
    if [[ ${counter} -eq 10 ]]; then
        # allow for a full recovery
        echo "waiting 1 hour, to allow full recovery"
        sleep 3600
    else
        echo "waiting ${INTERVAL} seconds"
        sleep ${INTERVAL}
    fi
done
