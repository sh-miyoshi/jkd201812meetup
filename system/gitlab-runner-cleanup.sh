#!/bin/bash

tmp=$(mktemp)

sed -e 's/<namespace>/projfrontend/g' template/gitlab-user.yaml > $tmp
kubectl delete -f $tmp
kubectl delete secret gitlab -n projfrontend
helm delete --purge projfrontend-runner

rm -rf $tmp
