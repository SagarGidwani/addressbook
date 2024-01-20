pipeline {
    agent any
    parameters{
        string(name:'env' , defaultValue:'Test' , description:'environment to compile')
    }

    stages {
        stage('compile') {
            steps {
                script{
                    echo "compile in env: ${params.env}"
                }
                
            }
        }
        stage('UnitTest') {
            steps {
                script{
                    echo 'UnitTEst-Hello World'
                }
                
            }
        }
         stage('package') {
            steps {
                script{
                    echo 'package-Hello World'
                }
                
            }
        }
    }
}
