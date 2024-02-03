pipeline {
    agent none
    tools {
        jdk 'myjava'
        maven 'mymaven' //not mentioning git because it is already installed manually on our server
    }
    parameters{
        string(name:'ENV' , defaultValue:'Test' , description:'environment to compile') 
        booleanParam(name:'EXECUTETESTS',defaultValue: true, description:'decide to run tc')
        choice(name:'APPVERSION',choices:['1.1', '1.2','1.3']) //by default the first value is considered if you dont give any default value
    } 

    environment{
        DEV_SERVER= 'ec2-user@172.31.36.74'
    }

    stages {
        stage('compile') {
            agent any   //this job will run on master as the slave is configured to build jobs with matching node labels
            steps {
                script{
                    echo "compile-hello world"
                    echo "compile in env: ${params.ENV}"
                    sh "mvn compile"
                }
                
            }
        }
        stage('UnitTest') {
            agent {label 'linux_slave'}   //running the package job on slave1 with label as linux_slave
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
                    sshagent(['aws-key']) {         //we had given the id as aws-key. So this stage will be executed on slave2
                    echo "package-Hello World"
                    echo "packaging the code version ${params.APPVERSION} "
                    sh "scp -o StrictHostKeyChecking=no server-config.sh ${DEV_SERVER}:/home/ec2-user" //copying server config file to the slave2 machine in the home dir of ec2-user scp=secure copy
                    sh "ssh -o StrictHostKeyChecking=no ${DEV_SERVER} 'bash ~/server-config.sh' " //from the master it is doing scp and ssh as the jenkinsfile script is being executed on the master
                     }
                
                }
            }
        }
        stage('deploy') {
            agent any
            input{              //input block will help you provide an input during runtime
                message "Select the version to deploy"
                ok "version selected"
                parameters{
                    choice(name: 'NEWVERSION', choices:['3.4','3.5','3.6'])
                }
            }
            steps {
                script{
                    echo "deploying the app"
                    echo "deploy the code version ${params.NEWVERSION} "
                }
                
            }
        }
    }
}
