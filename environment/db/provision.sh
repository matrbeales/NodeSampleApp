# get the gpg key
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927

# update the sources list
echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
sudo apt-get update -y

# install nginx
sudo apt-get install mongodb-org -y

# configure and restart mongo
sudo rm /etc/mongod.conf
sudo cp /db/templates/mongod.conf /etc/mongod.conf
sudo service mongod restart

# copy the profiles.d directory
sudo cp /home/ubuntu/profile.d/* /etc/profile.d