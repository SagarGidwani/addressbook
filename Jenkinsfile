pipeline {
    agent any
    parameters{
        string(name:'env' , defaultValue:'Test' , description:'environment to compile') 
        booleanParam(name:'executeTests',defaultValue: true, description:'decide to run tc')
        choice(name:'AppVersion',choices:['1.1', '1.2','1.3'])
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
            when{
                expression{
                    params.executeTests == true
                }
            }
            steps {
                script{
                    echo 'UnitTEst-Hello World'
                }
                
            }
        }
         stage('package') {
            steps {
                script{
                    echo "package-Hello World"
                    echo "packaging the code version ${param.AppVersion} "
                }
                
            }
        }
    }
}
