pipeline {
    agent none
    tools {
        jdk 'myjava'
        maven 'mymaven' 
    }

    environment{
        DEV_SERVER= 'ec2-user@172.31.12.52'
        IMAGE_NAME= "sagargidwani/java-mvn-privaterepos:${BUILD_NUMBER}"
        ACM_IP= 'ec2-user@172.31.38.67'
        AWS_ACCESS_KEY_ID =credentials("AWS_ACCESS_KEY_ID")
        AWS_SECRET_ACCESS_KEY=credentials("AWS_SECRET_ACCESS_KEY")
        DOCKER_REG_PASSWORD=credentials("DOCKER_REG_PASSWORD")
    }

    stages {
        stage('compile') {
            agent any   
            steps {
                script{
                    echo "compiling the code"
                    sh "mvn compile"
                }
                
            }
        }
        stage('UnitTest') {
            agent any   
            steps {
                script{
                    echo 'run the unit test'
                    sh "mvn test"
                } 
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
         stage('build the docker image') {
            agent any
            steps {
                script{
                    sshagent(['aws-key']) {     
                       withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'dockerpasswd', usernameVariable: 'dockeruser')]) {    
                    echo "containerising the app"
                    sh "scp -o StrictHostKeyChecking=no server-config.sh ${DEV_SERVER}:/home/ec2-user" 
                    sh "ssh -o StrictHostKeyChecking=no ${DEV_SERVER} 'bash ~/server-config.sh ${IMAGE_NAME}' "
                    sh 'ssh ${DEV_SERVER} sudo docker login -u ${dockeruser} -p ${dockerpasswd}'
                    sh "ssh ${DEV_SERVER} sudo docker push ${IMAGE_NAME}" 
                    }
                    }
                
                }
            }
        }
        
        stage("TF create EC2"){
               environment{
                 AWS_ACCESS_KEY_ID =credentials("AWS_ACCESS_KEY_ID")
                 AWS_SECRET_ACCESS_KEY=credentials("AWS_SECRET_ACCESS_KEY")
              }
            agent any
            steps{
                script{
                      //withCredentials([$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'yogita_aws_credentials', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']) {
                    dir("terraform"){
                        sh "terraform init"
                        sh "terraform apply -auto-approve"
                        EC2_PUBLIC_IP=sh(
                            script: "terraform output public-ip",
                            returnStdout: true
                        ).trim()
                    }

                }
            }
        
        }
        
        stage('deploy docker container through ansible') {
            agent any
            steps {
                script{
                    //echo "waiting for ec2 instance to initialise"
                    //sleep(time: 90, unit: "SECONDS")
                    sshagent(['aws-key']) {
                    echo "deploying the app"
                    sh "scp -o strictHostKeyChecking=no ansibe/* ${ACM_IP}:/home/ec2-user"
                    withCredentials([sshUserPrivateKey(credentialsId: 'Ansible-key' , keyFileVariable: 'keyfile' , usernameVariable: 'user' )]){
                        sh "scp -o strictHostKeyChecking=no $keyfile ${ACM_IP}:/home/ec2-user/.ssh/id_rsa"
                    }
                    sh "ssh -o strictHostKeyChecking=no ${ACM_IP} bash /home/ec2-user/prepare-ACM.sh ${AWS_ACCESS_KEY_ID} ${AWS_SECRET_ACCESS_KEY} ${IMAGE_NAME} ${DOCKER_REG_PASSWORD}"
                    }  
                }
            }
        }

    }
}
