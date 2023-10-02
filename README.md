```bash
# create cluster account
kubectl -n default create service account  <vadim>

# make cluster-admin
kubectl create clusterrolebinding  vadim-cluster-admin --clusterrole=cluster-admin --serviceaccount=default:vadim

# create access token
cat <<EOF | kubectl create -f -
apiVersion: v1
kind: Secret
metadata:
  name: vadim-token
  annotations:
    kubernetes.io/service-account.name: vadim
type: kubernetes.io/service-account-token
EOF

# copy token 
kubectl get secret vadim-token -o jsonpath="{.data.token}" | base64 -d
# TODO cert-manager, Ionos Issuer

# Prepare Apps
```bash
export NAMESPACE=iot4h
# github user
export $USER_NAME=<username>
exüprt USER_TOKEN=<token>

kubectl create namespace $NAMESPACE
kubectl create secret docker-registry iot4h-pullsecret -n $NAMESPACE -docker-server=ghcr.io --docker-username=$USER_NAME --docker-password=$USER_TOKEN


```

# Install Apps

```bash
#--insecure-skip-tls-verify
 helm upgrade --install -n $NAMESPACE iot4h .
```
## Run Migrations
```bash
#--insecure-skip-tls-verify
 helm upgrade --install -n $NAMESPACE iot4h . --set platform.upgradeFromVersion=<previous version
```