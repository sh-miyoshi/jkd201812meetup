#!/bin/bash

gitlabUrl="http:\/\/<your-server-ip>:30000"
gitlabUser="root"
gitlabPassword="mysecurepassword"
gitlabEMail="admin@example.com"
proj_frontend_token=""
proj_backend_token=""
proj_ops_token=""


tmp=$(mktemp)
sed -e 's/<namespace>/projfrontend/g' template/gitlab-user.yaml > $tmp
kubectl apply -f $tmp
kubectl create secret docker-registry gitlab \
    --docker-username="$gitlabUser" \
    --docker-password="$gitlabPassword" \
    --docker-email="$gitlabEMail" \
    --docker-server="$gitlabUrl" \
    -n projfrontend

sed "s/<gitlab-url>/$gitlabUrl/g" template/helm_values_gitlab-runner.yaml > $tmp
sed -i "s/<registration-token>/$proj_frontend_token/g" $tmp
helm install --name projfrontend-runner -n projfrontend -f $tmp gitlab/gitlab-runner

rm -rf $tmp
