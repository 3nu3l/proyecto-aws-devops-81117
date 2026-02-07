## Pequeño servicio de ejemplo en Python/Flask para el proyecto integrador de Cloud DevOps.

## Ejecutar local

```bash
python3 -m venv .venv
source .venv/bin/activate
# Windows: .venv\Scripts\activate
pip install -r requirements.txt
python app/main.py
```

## Secreto para autenticarse en ECR desde minikube
```bash
kubectl create secret -n <namespace> docker-registry regcred \
    --docker-server=<account-id>.dkr.ecr.<region>.amazonaws.com \
    --docker-username=AWS \
    --docker-password=$(aws ecr get-login-password --region <region>)
```