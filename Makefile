
# Get env vars from .env file
include .env
export

docker/build:
	docker build -t gcr.io/${PROJECT_ID}/httpd:$(shell date +%d-%m-%y-%H-%M) -f ./docker/Dockerfile .
	docker tag gcr.io/${PROJECT_ID}/httpd:$(shell date +%d-%m-%y-%H-%M) gcr.io/${PROJECT_ID}/httpd:latest
	docker push gcr.io/${PROJECT_ID}/httpd:$(shell date +%d-%m-%y-%H-%M)
	docker push gcr.io/${PROJECT_ID}/httpd:latest

TF_VAR_project ?= ${PROJECT_ID}
TF_VAR_cluster ?= ${CLUSTER}
terraform/bucket:
	gsutil mb -c standard -l us-central1 gs://${TF_STATE_BUCKET}

terraform/apply:
	cd terraform; \
	terraform apply -auto-approve

terraform/destroy:
	cd terraform; \
	terraform destroy

k8s/apply:
	gcloud container clusters get-credentials ${CLUSTER} --zone us-central1-c --project ${PROJECT_ID}
	kubectl apply -f ./k8s


provision: terraform/apply docker/build k8s/apply
destory: terraform/destroy
