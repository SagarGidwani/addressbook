pipeline{
    agent any
    parameters{
        string(name:'ENV', defaultValue:'test', description:'environment to compile')
        booleanParam(name:'EXECUTETESTS',defaultValue: true,description:'decide to run tc')
        choice(name:'APPVERSION',choices:['1.1','1.2','1.3'])
    }

    stages{
        stage('compile'){
            steps{
                script{
                    echo 'compile-hello world'
                    echo "compile in env : ${params.ENV}"
                }
            }
        }
        stage('UnitTest'){
            when{
                expression{
                    params.EXECUTETESTS == true
                }
            }
            steps{
                script{
                    echo 'UnitTest-hello world'
                }
            }
        }
        stage('package'){
            steps{
                script{
                    echo 'Package-hello world'
                    echo "packaging the code version : ${params.APPVERSION}"
                }
            }
        }
        stage('deploy'){
            input{
                message "select the version to deploy"
                ok "version selected"
                parameters{
                    choice(name:'NEWVERSION', choices:['3.3', '3.4','3.5'])
                }
            }
            steps{
                script{
                    echo "depolying the app"
                    echo "deploying the code version: ${params.APPVERSION}"
                }
            }
        }
    }
}