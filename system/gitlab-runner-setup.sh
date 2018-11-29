#!/bin/bash

gitlabUrl="http:\/\/<your-server-ip>"
gitlabUser="root"
gitlabPassword="mysecurepassword"
gitlabEMail="admin@example.com"
proj_frontend_token=""
proj_backend_token=""
proj_ops_token=""


tmp=$(mktemp)

#--------------------------------------
# ProjFrontend
#--------------------------------------
name="projfrontend"
sed -e "s/<namespace>/$name/g" template/gitlab-user.yaml > $tmp
kubectl apply -f $tmp
kubectl create secret docker-registry gitlab \
    --docker-username="$gitlabUser" \
    --docker-password="$gitlabPassword" \
    --docker-email="$gitlabEMail" \
    --docker-server="$gitlabUrl" \
    -n $name

sed "s/<gitlab-url>/$gitlabUrl/g" template/helm_values_gitlab-runner.yaml > $tmp
sed -i "s/<registration-token>/$proj_frontend_token/g" $tmp
helm install --name $name-runner --namespace $name -f $tmp gitlab/gitlab-runner

#--------------------------------------
# ProjBackend
#--------------------------------------
name="projbackend"
sed -e "s/<namespace>/$name/g" template/gitlab-user.yaml > $tmp
kubectl apply -f $tmp
kubectl create secret docker-registry gitlab \
    --docker-username="$gitlabUser" \
    --docker-password="$gitlabPassword" \
    --docker-email="$gitlabEMail" \
    --docker-server="$gitlabUrl" \
    -n $name

sed "s/<gitlab-url>/$gitlabUrl/g" template/helm_values_gitlab-runner.yaml > $tmp
sed -i "s/<registration-token>/$proj_backend_token/g" $tmp
helm install --name $name-runner --namespace $name -f $tmp gitlab/gitlab-runner

#--------------------------------------
# ProjOps(staging and production)
#--------------------------------------
name="staging"
sed -e "s/<namespace>/$name/g" template/gitlab-user.yaml > $tmp
kubectl apply -f $tmp
kubectl create secret docker-registry gitlab \
    --docker-username="$gitlabUser" \
    --docker-password="$gitlabPassword" \
    --docker-email="$gitlabEMail" \
    --docker-server="$gitlabUrl" \
    -n $name

name="production"
sed -e "s/<namespace>/$name/g" template/gitlab-user.yaml > $tmp
kubectl apply -f $tmp
kubectl create secret docker-registry gitlab \
    --docker-username="$gitlabUser" \
    --docker-password="$gitlabPassword" \
    --docker-email="$gitlabEMail" \
    --docker-server="$gitlabUrl" \
    -n $name

sed "s/<gitlab-url>/$gitlabUrl/g" template/helm_values_gitlab-runner.yaml > $tmp
sed -i "s/<registration-token>/$proj_ops_token/g" $tmp
helm install --name projops-runner --namespace $name -f $tmp gitlab/gitlab-runner

rm -rf $tmp
