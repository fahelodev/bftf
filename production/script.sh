#bash cicd
terraform plan
terraform apply --auto-approve

# acr y subida de imagenes
# az acr login -n barriofarmadevacr
# docker pull mcr.microsoft.com/mcr/hello-world
# docker tag mcr.microsoft.com/mcr/hello-world barriofarmadevacr.azurecr.io/samples/hello-world
# docker push barriofarmadevacr.azurecr.io/samples/hello-world

# k8s deploys
cd ..
az aks get-credentials --resource-group barriofarma-prod-cl-rg --name barriofarmaprod-aks --overwrite-existing
# kubectl get nodes
# sleep 3
kubectl apply -f k8s/nginx-loadbalancer
# kubectl get certificate | secret | describe secret
kubectl apply -f k8s/azure-cli
# watch kubectl get nodes
# kubectl get pods
# kubectl describe pods nginx-v2-788b5579fd-rv9v4
# kubectl get ing
# curl --resolve "echo.barriofarma.pvt:80:" http://echo.barriofarma.pvt
# ip dns 34.173.203.163
# terraform destroy --auto-approve
