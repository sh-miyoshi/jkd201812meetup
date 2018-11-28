#!/bin/bash

tmp=$(mktemp)

names=("projfrontend" "projbackend" "staging" "production")

for name in ${names[@]}; do
  kubectl delete secret gitlab -n $name
  sed -e "s/<namespace>/$name/g" template/gitlab-user.yaml > $tmp
  kubectl delete -f $tmp
done

helm delete --purge projfrontend-runner
helm delete --purge projbackend-runner
helm delete --purge projops-runner

rm -rf $tmp
