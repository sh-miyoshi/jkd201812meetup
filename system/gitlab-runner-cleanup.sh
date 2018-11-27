#!/bin/bash

tmp=$(mktemp)

names=("projfrontend" "projbackend" "staging" "production")

for name in ${names[@]}; do
  sed -e "s/<namespace>/$name/g" template/gitlab-user.yaml > $tmp
  kubectl delete -f $tmp
  kubectl delete secret gitlab -n $name
done

helm delete --purge projfrontend-runner
helm delete --purge projbackend-runner
helm delete --purge rojops-runner

rm -rf $tmp
