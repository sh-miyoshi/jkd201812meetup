#!/bin/bash

gitlabUrl="http:\/\/<your-server>"
gitlabHostname="gitlab.<your-domain>"
gitlabIpAddress="<ipaddress>"
gitlabUser="root"
gitlabPassword="mysecurepassword"
gitlabEMail="admin@example.com"
proj_frontend_token=""
proj_backend_token=""
proj_ops_token=""


tmp=$(mktemp)

kubectl apply -f template/gitlab-user.yaml

#--------------------------------------
# ProjFrontend
#--------------------------------------
name="projfrontend"
kubectl create secret docker-registry gitlab \
    --docker-username="$gitlabUser" \
    --docker-password="$gitlabPassword" \
    --docker-email="$gitlabEMail" \
    --docker-server="$gitlabUrl" \
    -n $name

sed "s/<gitlab-url>/$gitlabUrl/g" template/gitlab-runner.yaml > $tmp
token=`echo $proj_frontend_token | tr -d '\n' | base64`
sed -i "s/<registration-token>/$token/g" $tmp
sed -i "s/<name>/$name/g" $tmp
sed -i "s/<server-ip>/$gitlabIpAddress/g" $tmp
sed -i "s/<hostname>/$gitlabHostname/g" $tmp

kubectl apply -f $tmp

#--------------------------------------
# ProjBackend
#--------------------------------------
name="projbackend"
kubectl create secret docker-registry gitlab \
    --docker-username="$gitlabUser" \
    --docker-password="$gitlabPassword" \
    --docker-email="$gitlabEMail" \
    --docker-server="$gitlabUrl" \
    -n $name

sed "s/<gitlab-url>/$gitlabUrl/g" template/gitlab-runner.yaml > $tmp
token=`echo $proj_backend_token | tr -d '\n' | base64`
sed -i "s/<registration-token>/$token/g" $tmp
sed -i "s/<name>/$name/g" $tmp
sed -i "s/<server-ip>/$gitlabIpAddress/g" $tmp
sed -i "s/<hostname>/$gitlabHostname/g" $tmp

kubectl apply -f $tmp

#--------------------------------------
# ProjOps(staging and production)
#--------------------------------------
name="staging"
kubectl create secret docker-registry gitlab \
    --docker-username="$gitlabUser" \
    --docker-password="$gitlabPassword" \
    --docker-email="$gitlabEMail" \
    --docker-server="$gitlabUrl" \
    -n $name

name="production"
kubectl create secret docker-registry gitlab \
    --docker-username="$gitlabUser" \
    --docker-password="$gitlabPassword" \
    --docker-email="$gitlabEMail" \
    --docker-server="$gitlabUrl" \
    -n $name

sed "s/<gitlab-url>/$gitlabUrl/g" template/gitlab-runner.yaml > $tmp
token=`echo $proj_ops_token | tr -d '\n' | base64`
sed -i "s/<registration-token>/$token/g" $tmp
sed -i "s/<name>/$name/g" $tmp
sed -i "s/<server-ip>/$gitlabIpAddress/g" $tmp
sed -i "s/<hostname>/$gitlabHostname/g" $tmp

kubectl apply -f $tmp

rm -rf $tmp
