#!/bin/bash

if [ $# != 4 ]; then
  echo "Usage: $0 <apiserverImageName> <apiserverVersion> <mysqlImageName> <mysqlVersion>"
  exit 1
fi

apiserverImageName=$1
apiserverVersion=$2
mysqlImageName=$3
mysqlVersion=$4

cat << EOF > k8s-apiserver-deploy.yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: mysql-apiserver
  namespace: projbackend
  labels:
    app: mysql-apiserver
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: mysql-apiserver
    spec:
      containers:
      - name: mysql-apiserver
        image: ${apiserverImageName}:${apiserverVersion}
        env:
        - name: MYSQL_ADDR
          value: mysql.projbackend.svc.cluster.local
        ports:
          - containerPort: 4567
      imagePullSecrets:
      - name: gitlab
---
apiVersion: v1
kind: Service
metadata:
  name: mysql-apiserver
  labels:
    app: mysql-apiserver
  namespace: projbackend
spec:
  ports:
  - name: http
    port: 4567
    targetPort: 4567
  type: LoadBalancer
  selector:
    app: mysql-apiserver
EOF

cat << EOF > k8s-mysql-deploy.yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: mysql
  namespace: projbackend
  labels:
    app: mysql
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
      - name: mysql
        image: ${mysqlImageName}:${mysqlVersion}
        env:
        - name: MYSQL_ROOT_PASSWORD
          value: jkd201812
        ports:
        - containerPort: 3306
      imagePullSecrets:
      - name: gitlab
---
apiVersion: v1
kind: Service
metadata:
  name: mysql
  namespace: projbackend
  labels:
    app: mysql
spec:
  ports:
  - port: 3306
    targetPort: 3306
  selector:
    app: mysql
EOF