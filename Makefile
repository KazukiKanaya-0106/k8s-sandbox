.PHONY: build create load apply delete logs restart

# Build Docker Image
build:
	docker build -t k8s-sandbox:latest ./app

# Create KIND Cluster
create:
	kind create cluster --config=./k8s/kindconfig.yaml

# Load Image into KIND
load:
	kind load docker-image k8s-sandbox:latest

# Apply Kubernetes Manifests
apply:
	bash ./k8s/secret.sh
	kubectl apply -f ./k8s/configmap.yaml
	kubectl apply -f ./k8s/deploy.yaml
	kubectl apply -f ./k8s/service.yaml
	kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
	kubectl apply -f ./k8s/hpa.yaml
	kubectl label node kind-control-plane ingress-ready=true --overwrite
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.11.1/deploy/static/provider/kind/deploy.yaml
	kubectl wait -n ingress-nginx \
		--for=condition=Ready pod \
		-l app.kubernetes.io/component=controller \
		--timeout=480s
	kubectl apply -f ./k8s/ingress.yaml

# Restart Deployment
restart:
	kubectl rollout restart deploy k8s-sandbox

# Get logs
logs:
	kubectl logs -l app=k8s-sandbox

# Delete KIND Cluster
delete:
	kind delete cluster
