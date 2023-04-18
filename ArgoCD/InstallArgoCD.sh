kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply -f private-sshkey-secret.yaml -n microservices
kubectl create secret docker-registry pullsecret --namespace microservices --docker-server=microservicesb.azurecr.io --docker-username=microservicesB --docker-password=/DwvlliBTCPfsmH5z4bm8MNU6HHtgovSMvog4ITdy6+ACRAT68X1
kubectl apply -f application.yaml
kubectl port-forward svc/argocd-server -n argocd 8080:443