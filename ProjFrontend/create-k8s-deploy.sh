#!/bin/bash

if [ $# != 2 ]; then
  echo "Usage: $0 <imageName> <appVersion>"
  exit 1
fi

name=$1
version=$2

cat << EOF > k8s-deploy.yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: frontend
  namespace: projfrontend
  labels:
    app: frontend
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
      - name: frontend
        image: ${name}:${version}
        ports:
          - containerPort: 4567
        env:
        - name: API_SERVER_URL
          value: mysql-apiserver.projbackend.svc.cluster.local
      imagePullSecrets:
      - name: gitlab
---
apiVersion: v1
kind: Service
metadata:
  name: frontend
  labels:
    app: frontend
  namespace: projfrontend
spec:
  type: NodePort
  ports:
  - name: http
    port: 4567
    targetPort: 4567
    nodePort: 30010
  selector:
    app: frontend

EOF