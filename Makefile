aws eks update-kubeconfig --region us-east-2 --name education-eks-KUhqINko



#Note excute command above and using K9s 
kubectl delete -f nginx-deployment.yaml
kubectl apply -f nginx-deployment.yaml

kubectl apply -f hello-api/deployment.yaml

docker push sfgx8801234/hello-api:latest

docker buildx build --platform linux/amd64 -t sfgx8801234/hello-api:latest --push .

terraform init
terraform plan
terraform apply