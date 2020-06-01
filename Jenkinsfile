pipeline{
    agent any
    stages{
        stage("check out") {
            steps{
                git 'https://github.com/sridharpulangari/test-kube.git'
            }
        }
        stage("Deploy"){
            steps{
                sh "kubectl apply -f deployment.yaml"
                sh "kubectl apply -f service.yaml"
            }
        }
            
        
    }
}
