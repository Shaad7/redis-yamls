SHELL=/bin/bash -o pipefail

.PHONY : run-everything
run-everything: run-controller run-script

.PHONY : run-script
run-script : run-init-docker delete-sentinel sleep30 create-redis

.PHONY: deploy-enterprise-and-scale 
deploy-enterprise-and-scale: delete-cluster run-enterprise create-sentinel sleep60 scale


.PHONY: run-enterprise
run-enterprise:
	cd /home/shaad/go/src/kubedb.dev/enterprise && $(MAKE) uninstall
	sleep 5
	cd /home/shaad/go/src/kubedb.dev/enterprise && $(MAKE) deploy-to-kind 

.PHONY : scale
scale:
	-kubectl delete redisopsrequest redisops-horizontal -n demo
	kubectl apply -f /home/shaad/go/src/github.com/Shaad7/redis-yamls/kubedb-redis-yaml/redis-horizontal-ops.yaml
	  

.PHONY : run-init-docker
run-init-docker :
	cd /home/shaad/go/src/kubedb.dev/redis-init-docker && $(MAKE) push-to-kind

.PHONY : delete-sentinel 
 delete-sentinel : delete-redis sleep60  
	-kubectl delete redissentinel -n demo sentinel-redis
	

.PHONY : create-sentinel 
create-sentinel  : 
	kubectl apply -f /home/shaad/go/src/github.com/Shaad7/redis-yamls/Sentinel/yamls/sentinel-redis.yaml
	

.PHONY : create-redis 
create-redis : create-sentinel sleep120 
	kubectl apply -f /home/shaad/go/src/github.com/Shaad7/redis-yamls/Sentinel/yamls/redis.yaml

.PHONY : delete-redis 
delete-redis: 
	-kubectl delete rd redis -n demo

.PHONY : delete-ops-reqs 
delete-ops-reqs:
	-kubectl delete redisopsrequest -n demo  up-horizontal-redis-ops
	-kubectl delete redisopsrequest -n demo  down-horizontal-redis-ops
	-kubectl delete redisopsrequest -n demo  restart-redis-ops


.PHONY : run-controller 
run-controller : delete-cluster
	sleep 10
	cd /home/shaad/go/src/kubedb.dev/redis && $(MAKE) uninstall
	sleep 5
	cd /home/shaad/go/src/kubedb.dev/redis && $(MAKE) deploy-to-kind 


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
