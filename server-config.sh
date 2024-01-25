sudo yum install git -y 
sudo yum install java-1.8.0-openjdk-devel -y  #java 11 not required here
sudo yum install maven -y

if [ -d "addressbook"]
then
    echo "repo is cloned and exists"
    cd /home/ec2-user/addressbook
    git pull origin b1
else
    git clone https://github.com/SagarGidwani/addressbook.git  #it will clone in the home dir of ec2-user because this job is run by slave 2 default user ec2-user
    cd addressbook
    git checkout b1  #by default it will go to master branch but the jenkins file is kept on b1 brancg and jenkins is alse confugured to pull from b1 branch
fi

mvn package
