pipeline {
    agent any

    environment {
        APP_NAME     = 'techzen-app'
        DOCKER_PORT  = '8081'
        SSH_CRED_ID  = 'sshkey'

        SSH_HOST     = '172.19.0.1'
        SSH_PORT     = '22'
        SSH_USER     = 'academy'

        TARGET_DIR   = '/home/academy/docker/database'
    }

    stages {
        stage('Checkout Source Code') {
            steps {
                echo '===> [STAGE 1] Bắt đầu lấy mã nguồn mới nhất từ GitHub...'
                git branch: 'main', credentialsId: 'github-token', url: 'https://github.com/vunguyen109/devops-example.git'
            }
        }

        stage('Deploy via SSH') {
            steps {
                echo "===> [STAGE 2] SSH vào Host và Triển khai Docker Compose trên Port: ${DOCKER_PORT}..."
                // Sử dụng withCredentials lấy trực tiếp file private key
                withCredentials([sshUserPrivateKey(credentialsId: env.SSH_CRED_ID, keyFileVariable: 'SSH_KEY')]) {
                    sh '''
                        SSH_OPTS="-i ${SSH_KEY} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p ${SSH_PORT}"

                        ssh ${SSH_OPTS} ${SSH_USER}@${SSH_HOST} "
                            cd ${TARGET_DIR}
                            echo '===> Đang dừng container cũ...'
                            docker compose down || true
                            echo '===> Đang build và chạy container mới...'
                            docker compose up -d --build
                        "
                    '''
                }
            }
        }

        stage('Health Check via SSH') {
            steps {
                echo "===> [STAGE 3] Kiểm tra trạng thái hoạt động của Container..."
                withCredentials([sshUserPrivateKey(credentialsId: env.SSH_CRED_ID, keyFileVariable: 'SSH_KEY')]) {
                    sh '''
                        SSH_OPTS="-i ${SSH_KEY} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p ${SSH_PORT}"

                        ssh ${SSH_OPTS} ${SSH_USER}@${SSH_HOST} "
                            docker ps --filter 'status=running'
                        "
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "🚀 [DEPLOY SUCCESS] Ứng dụng đã được triển khai tự động thành công!"
            echo "👉 Truy cập ngay tại: http://<IP_VPS>:${DOCKER_PORT}"
        }
        failure {
            echo "❌ [DEPLOY FAILED] Pipeline thất bại! Vui lòng kiểm tra Console Output."
        }
    }
}
