SHELL=/bin/bash -o pipefail

.PHONY: clean-issuer
clean-issuer:
	-kubectl delete issuer -n demo redis-ca-issuer
	-kubectl delete secret -n demo redis-ca

.PHONY : create-issuer
create-issuer:
	-kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.8.0/cert-manager.yaml
	sleep 15
	cd /home/shaad/go/src/github.com/Shaad7/redis-yamls/kubedb-redis-yaml/reconfigure-tls && openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ./ca.key -out ./ca.crt -subj "/CN=redis/O=kubedb"
	-cd /home/shaad/go/src/github.com/Shaad7/redis-yamls/kubedb-redis-yaml/reconfigure-tls && kubectl create secret tls redis-ca --cert=ca.crt  --key=ca.key --namespace=demo
	sleep 15
	kubectl apply -f /home/shaad/go/src/github.com/Shaad7/redis-yamls/kubedb-redis-yaml/reconfigure-tls/demo-issuer.yaml


.PHONY: clean-updated-issuer
clean-updated-issuer:
	-kubectl delete issuer -n demo redis-ca-issuer-updated
	-kubectl delete secret -n demo redis-ca-updated

.PHONY : create-updated-issuer
create-updated-issuer:
	-kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.8.0/cert-manager.yaml
	sleep 15
	cd /home/shaad/go/src/github.com/Shaad7/redis-yamls/kubedb-redis-yaml/reconfigure-tls && openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ./ca.key -out ./ca.crt -subj "/CN=redis-updated/O=kubedb-updated"
	-cd /home/shaad/go/src/github.com/Shaad7/redis-yamls/kubedb-redis-yaml/reconfigure-tls && kubectl create secret tls redis-ca-updated --cert=ca.crt  --key=ca.key --namespace=demo
	sleep 15
	kubectl apply -f /home/shaad/go/src/github.com/Shaad7/redis-yamls/kubedb-redis-yaml/reconfigure-tls//demo-issuer-updated.yaml

.PHONY : run-everything
run-everything: run-controller run-script

.PHONY : run-script
run-script : run-init-docker delete-cluster sleep30 create-cluster

.PHONY: deploy-enterprise-and-scale 
deploy-enterprise-and-scale: delete-cluster run-enterprise create-cluster sleep60 scale


.PHONY: run-enterprise
run-enterprise:
	cd /home/shaad/go/src/kubedb.dev/enterprise && $(MAKE) uninstall
	sleep 5
	cd /home/shaad/go/src/kubedb.dev/enterprise && $(MAKE) deploy-to-kind 

.PHONY : scale
scale:
	-kubectl delete redisopsrequest redisops-horizontal -n demo
	kubectl apply -f /home/shaad/go/src/github.com/Shaad7/redis-yamls/kubedb-redis-yaml/redis-horizontal-ops.yaml


.PHONY : run-and-load-node-finder 
run-and-load-node-finder : build-redis-node-finder 
	cp -r /home/shaad/go/src/github.com/Shaad7/redis-node-finder/redis-node-finder /home/shaad/go/src/kubedb.dev/redis-init-docker/scripts/cluster-shard-scripts/

.PHONY : build-redis-node-finder
build-redis-node-finder: 
	cd /home/shaad/go/src/github.com/Shaad7/redis-node-finder &&  go build -o redis-node-finder .
	  

.PHONY : run-init-docker
run-init-docker :
	cd /home/shaad/go/src/kubedb.dev/redis-init-docker && $(MAKE) push-to-kind

.PHONY : delete-cluster 
delete-cluster : 
	-kubectl delete rd redis-cluster -n demo
	-kubectl delete redisopsrequest -n demo  up-horizontal-redis-ops
	-kubectl delete redisopsrequest -n demo  down-horizontal-redis-ops
	-kubectl delete redisopsrequest -n demo  restart-redis-ops

.PHONY : create-cluster 
create-cluster : 
	kubectl apply -f /home/shaad/go/src/github.com/Shaad7/redis-yamls/kubedb-redis-yaml/redis-cluster.yaml


.PHONY : run-controller 
run-controller : delete-cluster
	sleep 10
	cd /home/shaad/go/src/kubedb.dev/redis && $(MAKE) uninstall
	sleep 5
	cd /home/shaad/go/src/kubedb.dev/redis && $(MAKE) deploy-to-kind 


.PHONY : create-cluster-prev
create-cluster-prev:
	kubectl apply -f /home/shaad/go/src/github.com/Shaad7/redis-yamls/kubedb-redis-yaml/demo-prev.yaml

.PHONY : run-controller-prev 
run-controller-prev: run-controller sleep30 create-cluster-prev

.PHONY: sleep90 
sleep90:
	sleep 90

.PHONY: sleep60
sleep60:
	sleep 60

.PHONY: sleep30
sleep30:
	sleep 30

.PHONY: sleep120
sleep120:
	sleep 120

.PHONY: sleep180
sleep180:
	sleep 180
