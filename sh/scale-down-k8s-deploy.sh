#!/bin/bash

echo "Scale down all deployment to 0"

array=($(kubectl get deployment -o=jsonpath='{range .items[*]}{.metadata.name}{" "}'))

for (( c=0; c<${#array[@]}; c++))
do
	service=($(kubectl get deployment -o=jsonpath='{range .items['$c']}{.metadata.name}{""}'))

	echo "Start scaling down" $service
    kubectl patch deployment $service -p \
      '{"spec":{"replicas":0}}' --record=true

	if [ "$?" != "0" ]; then
        echo $service "patching failed"
        continue
    fi

	echo "Successfully scaled down " $service
done

echo "Scale down complete"



