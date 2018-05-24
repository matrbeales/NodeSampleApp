#!/bin/bash
export DB_HOST=mongodb://${db_endpoint}/example
cd /home/ubuntu/app
npm start