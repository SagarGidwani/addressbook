pipeline {
    agent none
    tools {
        jdk 'myjava'
        maven 'mymaven' 
    }
    parameters{
        string(name:'ENV' , defaultValue:'Test' , description:'environment to compile') 
        booleanParam(name:'EXECUTETESTS',defaultValue: true, description:'decide to run tc')
        choice(name:'APPVERSION',choices:['1.1', '1.2','1.3']) 
    } 

    environment{
        DEV_SERVER= 'ec2-user@172.31.36.236'
        DEPLOY_SERVER= 'ec2-user@172.31.37.66'
        IMAGE_NAME= 'sagargidwani/java-mvn-privaterepos'
    }

    stages {
        stage('compile') {
            agent any   
            steps {
                script{
                    echo "compile-hello world"
                    echo "compile in env: ${params.ENV}"
                    sh "mvn compile"
                }
                
            }
        }
        stage('UnitTest') {
            agent any   
            when{
                expression{
                    params.EXECUTETESTS == true
                }
            }
            steps {
                script{
                    echo 'UnitTest-Hello World'
                    sh "mvn test"
                } 
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
         stage('package') {
            agent any
            steps {
                script{
                    sshagent(['aws-key']) {     
                       withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'dockerpasswd', usernameVariable: 'dockeruser')]) {    
                    echo "package-Hello World"
                    echo "packaging the code version ${params.APPVERSION} "
                    sh "scp -o StrictHostKeyChecking=no server-config.sh ${DEV_SERVER}:/home/ec2-user" 
                    sh "ssh -o StrictHostKeyChecking=no ${DEV_SERVER} 'bash ~/server-config.sh ${IMAGE_NAME} ${BUILD_NUMBER}' "
                    sh 'ssh ${DEV_SERVER} sudo docker login -u ${dockeruser} -p ${dockerpasswd}'
                    sh "ssh ${DEV_SERVER} sudo docker push ${IMAGE_NAME}:${BUILD_NUMBER}" 
                    }
                    }
                
                }
            }
        }
        stage('deploy') {
            agent any
            input{              
                message "Select the version to deploy"
                ok "version selected"
                parameters{
                    choice(name: 'NEWVERSION', choices:['3.4','3.5','3.6'])
                }
            }
            steps {
                script{
                    sshagent(['aws-key']) {
                        withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'dockerpasswd', usernameVariable: 'dockeruser')]) {
                    echo "deploying the app"
                    echo "deploy the code version ${params.NEWVERSION} "
                    sh "ssh -o StrictHostKeyChecking=no ${DEPLOY_SERVER} sudo yum install docker -y "
                    sh "ssh ${DEPLOY_SERVER} sudo docker login -u ${dockeruser} -p ${dockerpasswd}"
                    sh "ssh ${DEPLOY_SERVER} sudo docker run -itd -P ${IMAGE_NAME}:${BUILD_NUMBER} "
                }
                } 
            }
        }
    }

    }
}