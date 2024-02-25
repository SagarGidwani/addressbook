pipeline {
    agent none
    tools {
        jdk 'myjava'
        maven 'mymaven' 
    }

    environment{
       // DEV_SERVER= 'ec2-user@172.31.34.67'
        IMAGE_NAME= 'sagargidwani/java-mvn-privaterepos'
    }

   /* stages {
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
                    sh "ssh -o StrictHostKeyChecking=no ${DEV_SERVER} 'bash ~/server-config.sh ${IMAGE_NAME} ${BUILD_NUMBER}' "
                    sh 'ssh ${DEV_SERVER} sudo docker login -u ${dockeruser} -p ${dockerpasswd}'
                    sh "ssh ${DEV_SERVER} sudo docker push ${IMAGE_NAME}:${BUILD_NUMBER}" 
                    }
                    }
                
                }
            }
        }
        */
        stage("TF create EC2"){
            agent any
            steps{
                script{
                    environment{
                        AWS_ACCESS_KEY_ID =credentials("AWS_ACCESS_KEY_ID")
                        AWS_SECRET_ACCESS_KEY=credentials("AWS_SECRET_ACCESS_KEY")
                    }
                    //withCredentials([$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'yogita_aws_credentials', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']) {
                    dir("terraform")
                        sh "terraform init"
                        sh "terraform apply -auto-approve"
                        EC2_PUBLIC_IP=sh(
                            script: "terraform output public-ip",
                            returnStdout: true
                        ).trim()

                }
            }
        }
        
        stage('deploy docker container') {
            agent any
            steps {
                script{
                    echo "waiting for ec2 instance to initialise"
                    sleep(time: 90, unit: "SECONDS")
                    sshagent(['aws-key']) {
                        withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'dockerpasswd', usernameVariable: 'dockeruser')]) {
                    echo "deploying the app"
                    sh "ssh -o StrictHostKeyChecking=no ${DEPLOY_SERVER} sudo yum install docker -y "
                    sh "ssh ec2-user@${EC2_PUBLIC_IP} sudo systemctl start docker"
                    sh "ssh ec2-user@${EC2_PUBLIC_IP} sudo docker login -u ${dockeruser} -p ${dockerpasswd}"
                    sh "ssh ec2-user@${EC2_PUBLIC_IP} sudo docker run -itd -p 8081:8080 ${IMAGE_NAME}:8 "
                }
                }  
            }
        }
    }

    }
}