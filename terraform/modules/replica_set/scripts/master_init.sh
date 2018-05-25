#!/bin/bash
export LC_ALL=C

sudo service mongod stop
private_ip=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
sudo mongod --replSet '${replica_set_name}' --bind_ip localhost,$private_ip --config=/etc/mongod.conf

mongo <<EOF
    rs.initiate( {
       _id : "${replica_set_name}",
       members: [
          { _id: 0, host: "$private_ip:27017" },
          { _id: 1, host: "${replica_one}" },
          { _id: 2, host: "${replica_two}" }
       ]
    })
EOF