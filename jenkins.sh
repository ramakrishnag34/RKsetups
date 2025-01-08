#STEP-1: INSTALLING GIT JAVA-1.8.0 MAVEN 
yum install git tree maven -y

#STEP-2: GETTING THE REPO (jenkins.io --> download -- > redhat)
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

#STEP-3: DOWNLOAD JAVA11 AND JENKINS
sudo amazon-linux-extras enable corretto17
sudo yum install -y java-17-openjdk
 yum install fontconfig java-17-openjdk
yum install jenkins
update-alternatives --config java

#STEP-4: RESTARTING JENKINS (when we download service it will on stopped state)
systemctl start jenkins.service
systemctl status jenkins.service
