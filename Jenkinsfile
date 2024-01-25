pipeline {
    agent any
    tools {
        jdk 'myjava'
        maven 'mymaven' //not mentioning git because it is already installed manually on our server
    }
    parameters{
        string(name:'ENV' , defaultValue:'Test' , description:'environment to compile') 
        booleanParam(name:'EXECUTETESTS',defaultValue: true, description:'decide to run tc')
        choice(name:'APPVERSION',choices:['1.1', '1.2','1.3']) //by default the first value is considered if you dont give any default value
    } 

    stages {
        stage('compile') {
            steps {
                script{
                    echo "compile-hello world"
                    echo "compile in env: ${params.ENV}"
                    sh "mvn compile"
                }
                
            }
        }
        stage('UnitTest') {
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
        }
         stage('package') {
            steps {
                script{
                    echo "package-Hello World"
                    echo "packaging the code version ${params.APPVERSION} "
                    sh "mvn package"
                }
                
            }
        }
        stage('deploy') {
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