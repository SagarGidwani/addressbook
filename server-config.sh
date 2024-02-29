sudo yum install git -y 
sudo yum install docker -y 
sudo systemctl start docker 

if [ -d "addressbook"]
then
    echo "repo is cloned and exists"
    cd /home/ec2-user/addressbook
    git pull origin ansible-docker
else
    git clone https://github.com/SagarGidwani/addressbook.git 
    cd addressbook
    git checkout ansible-docker
fi

sudo docker build -t $1 /home/ec2-user/addressbook