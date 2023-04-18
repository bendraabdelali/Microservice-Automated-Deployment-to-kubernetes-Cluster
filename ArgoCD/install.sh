kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply -f private-sshkey-secret.yaml -n microservices

kubectl create secret docker-registry pullsecret --namespace microservices --docker-server=*************** --docker-username=************** --docker-password=**************

kubectl apply -f application.yaml
kubectl port-forward svc/argocd-server -n argocd 8080:443