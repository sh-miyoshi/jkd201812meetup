#!/bin/bash

tmp=$(mktemp)

names=("projfrontend" "projbackend" "staging" "production")

kubectl delete -f template/gitlab-user.yaml

for name in ${names[@]}; do
  kubectl delete secret gitlab -n $name
done

sed "s/<name>/projfrontend/g" template/gitlab-runner.yaml > $tmp
kubectl delete -f $tmp
sed "s/<name>/projbackend/g" template/gitlab-runner.yaml > $tmp
kubectl delete -f $tmp
sed "s/<name>/production/g" template/gitlab-runner.yaml > $tmp
kubectl delete -f $tmp

rm -rf $tmp
