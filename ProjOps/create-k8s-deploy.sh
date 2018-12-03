#!/bin/bash

if [ $# != 7 ]; then
  echo "Usage: $0 <namespace> <frontendImage> <frontendVersion> <apiserverImageName> <apiserverVersion> <mysqlImageName> <mysqlVersion>"
  exit 1
fi

namespace=$1
frontendImage=$2
frontendVersion=$3
apiserverImageName=$4
apiserverVersion=$5
mysqlImageName=$6
mysqlVersion=$7

password="jkd201812"

cat << EOF > k8s-deploy.yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: frontend
  namespace: ${namespace}
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
        image: ${frontendImage}:${frontendVersion}
        ports:
          - containerPort: 4567
        env:
        - name: API_SERVER_URL
          value: mysql-apiserver.${namespace}.svc.cluster.local
      imagePullSecrets:
      - name: gitlab
---
apiVersion: v1
kind: Service
metadata:
  name: frontend
  labels:
    app: frontend
  namespace: ${namespace}
spec:
  type: ClusterIP
  ports:
  - name: http
    port: 4567
    targetPort: 4567
  selector:
    app: frontend
---
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: mysql-apiserver
  namespace: ${namespace}
  labels:
    app: mysql-apiserver
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: mysql-apiserver
        version: v1
    spec:
      containers:
      - name: mysql-apiserver
        image: ${apiserverImageName}:${apiserverVersion}
        env:
        - name: MYSQL_ADDR
          value: mysql.${namespace}.svc.cluster.local
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
  namespace: ${namespace}
spec:
  ports:
  - name: http
    port: 4567
    targetPort: 4567
  type: ClusterIP
  selector:
    app: mysql-apiserver
---
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: mysql
  namespace: ${namespace}
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
          value: ${password}
        ports:
        - containerPort: 3306
      imagePullSecrets:
      - name: gitlab
---
apiVersion: v1
kind: Service
metadata:
  name: mysql
  namespace: ${namespace}
  labels:
    app: mysql
spec:
  ports:
  - port: 3306
    targetPort: 3306
  selector:
    app: mysql
---
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: frontend-gateway
  namespace: ${namespace}
spec:
  selector:
    istio: ingressgateway # use Istio default gateway implementation
  servers:
  - port:
      number: 80
      name: http
      protocol: HTTP
    hosts:
    - "*"
---
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: frontend
  namespace: ${namespace}
spec:
  hosts:
  - "*"
  gateways:
  - frontend-gateway
  http:
  - match:
    - uri:
        prefix: /
    - uri:
        prefix: /data
    route:
    - destination:
        port:
          number: 4567
        host: frontend
EOF