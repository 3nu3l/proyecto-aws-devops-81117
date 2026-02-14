kubectl apply -f orders-api/namespace.yaml
kubectl create secret -n orders-api  docker-registry regcred \
    --docker-server=781013578291.dkr.ecr.us-east-1.amazonaws.com \
    --docker-username=AWS \
    --docker-password=$(aws ecr get-login-password --region us-east-1)
kubectl apply -f orders-api/deployment.yaml
kubectl apply -f orders-api/service.yaml