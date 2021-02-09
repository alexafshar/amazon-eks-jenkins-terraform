#!/bin/bash
sudo yum -y update

echo "Install Java JDK 8"
sudo yum remove -y java
sudo yum install -y java-1.8.0-openjdk

echo "Install Maven"
sudo yum install -y maven

echo "Install git"
sudo yum install -y git


echo "Install jenkins needed secy componets"
sudo yum install -y ca-certificates curl gnupg2

echo "Install Docker engine"
sudo yum update -y
sudo yum install docker -y

# start docker before any other docker commands
sudo service docker start

echo "install dockerized Jenkins and plugins"
cd /tmp
sudo docker build -t popularowl/jenkins .

sudo sudo chkconfig docker on
sudo amazon-linux-extras install -y ansible2
# epel repo needed to get ufw
#sudo amazon-linux-extras install -y epel
#sudo yum install --enablerepo="epel" ufw -y
#sudo ufw status verbose
#sudo ufw default deny incoming
#sudo ufw default allow outgoing
#sudo ufw allow ssh
#sudo ufw allow 22
#sudo ufw allow 80
#sudo yes | ufw enable
# update nginx configuration
sudo rm -f /etc/nginx/sites-enabled/default
sudo cp -f /tmp/jenkins-proxy /etc/nginx/sites-enabled
sudo service nginx restart


# uncomment if installing Jenkins without docker
#sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
#sudo rpm --import  https://pkg.jenkins.io/redhat/jenkins.io.key
#sudo yum install -y jenkins
#sudo usermod -a -G docker jenkins
#sudo chkconfig jenkins on

# echo "Start Docker & Jenkins services"
#sudo service jenkins start
