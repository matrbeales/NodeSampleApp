#!/bin/bash
export LC_ALL=C
sudo service mongod stop
private_ip=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
sudo mongod --replSet '${replica_set_name}' --bind_ip localhost,$private_ip --config=/etc/mongod.conf