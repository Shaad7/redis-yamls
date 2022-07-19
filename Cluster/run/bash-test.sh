#!/bin/bash

nodes_conf="2f1a3c34b741fa9ed840015f7ac326edf03038c5 10.244.0.5:6379@16379 myself,slave 21d11f50d5a3ec7327933deb3182ea85f2afb62e 0 1647579450000 4 connected
d9c7565c6c8c77984efb98a9d052bc14b0af345a 10.244.0.9:6379@16379 master - 0 1647579450894 1 connected 0-5460
9d718cc1c32aaba226a97b74760ae048ed952a43 10.244.0.8:6379@16379 master - 0 1647579450000 2 connected 5461-10922
21d11f50d5a3ec7327933deb3182ea85f2afb62e 10.244.0.10:6379@16379 master - 0 1647579450000 4 connected 10923-16383
f07920257d9e601e347e694ac7215735b092bb8f 10.244.0.7:6379@16379 slave 9d718cc1c32aaba226a97b74760ae048ed952a43 0 1647579451898 2 connected
7a7d7c3c7e3868e30358ea82f7f30c066ebd1edc 10.244.0.3:6379@16379 slave d9c7565c6c8c77984efb98a9d052bc14b0af345a 0 1647579450000 1 connected"


redis_nodes=("redis-cluster-shard0-0.redis-cluster-pods.demo.svc"
   "redis-cluster-shard0-1.redis-cluster-pods.demo.svc"
   "redis-cluster-shard1-0.redis-cluster-pods.demo.svc"
   "redis-cluster-shard1-1.redis-cluster-pods.demo.svc"
   "redis-cluster-shard2-0.redis-cluster-pods.demo.svc"
   "redis-cluster-shard2-1.redis-cluster-pods.demo.svc")

old_nodes_conf="43e91e41c328689700e70f333b041a8ce0dd2dee 10.244.0.151:6379@16379 master - 0 1648100088403 1 connected 0-5460
0e2bb91d5bd63ae78281012cdb402762899e5fb3 10.244.0.162:6379@16379 master - 0 1648100088808 3 connected 10923-16383
1b5364c51c1557710e019fef3124ca33b2a4098a 10.244.0.161:6379@16379 master - 0 1648100088405 2 connected 5461-10922
58e7048368cdbdb42569a65fe6ac3136817cdb15 10.244.0.166:6379@16379 slave 1b5364c51c1557710e019fef3124ca33b2a4098a 0 1648100088505 2 connected
a850aabc4f829e7666aeb1fe5d16d485f2fbb81c 10.244.0.160:6379@16379 slave 43e91e41c328689700e70f333b041a8ce0dd2dee 0 1648100088404 1 connected
3dc411da90350155d05ff4b67e5fae1f330de780 10.244.0.165:6379@16379 myself,slave 0e2bb91d5bd63ae78281012cdb402762899e5fb3 0 1648100088000 3 connected"


readonly node_flag_no_addr="noaddr"
readonly node_flag_master="master"
readonly node_flag_slave="slave"
readonly node_flag_myself="myself"
readonly node_flag_fail="fail"
readonly cluster_suffix="cluster.local"

HOSTNAME="redis-cluster-shard0-0"
REDIS_GOVERNING_SERVICE="redis-cluster-pods.demo.svc"


POD_ADDRESS=("10.244.0.85:6379" "10.244.0.86:6379" "10.244.0.84:6379")
CUR_POD_IP_PORT="10.244.0.86:6379"

master_nodes_ip_port=("10.244.0.59:6379" "10.244.0.63:6379" "10.244.0.61:6379")
cur_node_ip_port="10.244.0.65:6379"
POD_IP="10.244.0.218"
cur_node_ip="10.244.0.151"

MASTER=3
REPLICAS=1


function testFunction() {
    if [[ ! $old_nodes_conf =~ $cur_node_ip || ! $nodes_conf =~ $cur_node_ip ]] ; then
        echo "Meet between $POD_IP and $cur_node_ip is $RESP"
    else
        echo "don't know"
    fi 
}

testFunction
