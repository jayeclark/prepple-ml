#!/bin/bash
sudo yum -y update

echo "Install Java JDK 11"
sudo yum remove -y java
sudo yum install -y java-11-openjdk

echo "Install Maven"
sudo yum install -y maven 

echo "Install Python 3.9"
sudo yum remove -y python3
sudo yum install -y python3

echo "Install git"
sudo sudo yum install -y git

echo "Install Docker engine"
sudo yum update -y
sudo yum install docker -y
sudo usermod -a -G docker jenkins
sudo service docker start
sudo chkconfig docker on

echo "Install Jenkins"
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo amazon-linux-extras install epel
sudo yum install -y jenkins
sudo systemctl enable jenkins
sudo systemctl enable docker
sudo usermod -a -G docker jenkins
sudo chkconfig jenkins on
sudo systemctl start docker
sudo systemctl start jenkins

