 # on the server rancher1
 # add helm
curl -L https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

 # add needed helm charts
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
helm repo add jetstack https://charts.jetstack.io


 # add the cert-manager CRD
 kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.6.1/cert-manager.crds.yaml

 # helm install jetstack
 helm upgrade -i cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace

 # helm install rancher
 helm upgrade -i rancher rancher-latest/rancher --create-namespace --namespace cattle-system --set hostname=rancher.dockr.life --set bootstrapPassword=bootStrapAllTheThings --set replicas=1 
#  -- set global.cattle.psp.enabled: false