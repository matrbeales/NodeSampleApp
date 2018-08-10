#!/bin/bash
export DB_HOST=mongodb://${db_endpoint}
cd /home/ubuntu/app
npm start