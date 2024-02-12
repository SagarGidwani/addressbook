sudo yum install git -y 

sudo yum install docker -y 
sudo systemctl start docker 

if [ -d "addressbook"]
then
    echo "repo is cloned and exists"
    cd /home/ec2-user/addressbook
    git pull origin b1
else
    git clone https://github.com/SagarGidwani/addressbook.git 
    cd addressbook
    git checkout b1 
fi

sudo docker build -t $1:v$2 /home/ec2-user/addressbook