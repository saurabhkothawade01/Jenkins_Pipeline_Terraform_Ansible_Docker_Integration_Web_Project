pipeline {
    agent any
    
    triggers {
        pollSCM('* * * * *')
    }

    stages {
        stage('Checkout Code from GitHub') {
            steps {
                git branch: 'master', credentialsId: 'saurabhk', url: 'https://github.com/saurabhkothawade01/Jenkins_Pipeline_Terraform_Ansible_Docker_Integration_Web_Project.git'
            }
        }

        stage('Terraform Provisioning') {
            steps {
                script {
                    sh 'sudo terraform init'
                    sh 'sudo terraform apply -auto-approve'
                }
            }
        }

        stage('Ansible Configuration') {
            steps {
                script {
                    sh 'ansible-navigator run configure_instance.yml -i inventory --ee false --mode stdout --lf ~/ansible-navigator.log'
                }
            }
        }

        stage('Build Docker Images and Launch Docker Container') {
            steps {
                script {
                    def instanceIP = sh(script: 'terraform output | awk -F= \'/instance/ {gsub(/"/, "", $2); print $2}\' | tr -d " "', returnStdout: true).trim()

                    def timestamp = new Date().format('yyyyMMdd-HHmmss')
                    def webServerImage = "web-server:$timestamp"
                    def haproxyImage = "haproxy-lb:$timestamp"

                    sh "scp -i ../myterraformkey Dockerfile.haproxy Dockerfile.httpd haproxy.cfg index.html entrypoint.sh ec2-user@${instanceIP}:/home/ec2-user/"

                    sh "ssh -i ../myterraformkey ec2-user@${instanceIP} 'cd /home/ec2-user/ && sudo docker build -t $webServerImage -f Dockerfile.httpd . && sudo docker build -t $haproxyImage -f Dockerfile.haproxy .'"

                    for (int i = 1; i <= 2; i++) {
                        def containerName = "web-server${i}"
                        
                        sh "ssh -i ../myterraformkey ec2-user@${instanceIP} 'sudo docker stop ${containerName} || true'"
                        sh "ssh -i ../myterraformkey ec2-user@${instanceIP} 'sudo docker rm ${containerName} || true'"
                        
                        sh "ssh -i ../myterraformkey ec2-user@${instanceIP} 'sudo docker run -d --name ${containerName} $webServerImage'"
                    }

                    sh "ssh -i ../myterraformkey ec2-user@${instanceIP} 'sudo docker stop haproxy-lb || true'" 
                    sh "ssh -i ../myterraformkey ec2-user@${instanceIP} 'sudo docker rm haproxy-lb || true'"
            
                    
                    sh "ssh -i ../myterraformkey ec2-user@${instanceIP} 'sudo docker run -d -p 1235:80 --name haproxy-lb --link web-server1:web-server1 --link web-server2:web-server2 $haproxyImage'"

                }
            }
        }

	stage('Show Website URL') {
            steps {
                script {
                    def instanceIP = sh(script: 'terraform output | awk -F= \'/instance/ {gsub(/"/, "", $2); print $2}\' | tr -d " "', returnStdout: true).trim()

                    echo "Website URL: http://${instanceIP}:1235"
                }
            }
        }
    }

    post {
        success {
            echo 'CI/CD pipeline successfully completed!'
        }
        failure {
            echo 'CI/CD pipeline failed!'
        }
    }
}
