#!/bin/bash

curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | sh -

kubectl -n kube-system create sa tiller
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account tiller
helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com/
helm repo add gitlab https://charts.gitlab.io

#echo "source <(helm completion bash)" >> ~/.bash_profile
#source ~/.bash_profile
