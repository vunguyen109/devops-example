pipeline {
    agent any

    environment {
        APP_NAME = 'techzen-app'
        DOCKER_PORT = '8081'
    }

    stages {
        stage('Checkout Source Code') {
            steps {
                echo '===> [STAGE 1] Bắt đầu lấy mã nguồn mới nhất từ GitHub...'
                // Lưu ý cho học viên: Thay thế URL repository GitHub của bạn bên dưới
                git branch: 'main', credentialsId: 'github-token', url: 'https://github.com/vunguyen109/devops-example.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "===> [STAGE 2] Đóng gói Docker image: ${APP_NAME}:latest từ Dockerfile..."
                sh 'docker build -t ${APP_NAME}:latest .'
            }
        }

        stage('Deploy Container on VPS') {
            steps {
                echo "===> [STAGE 3] Triển khai Container với Docker Compose trên Port: ${DOCKER_PORT}..."
                // Sử dụng Docker Compose để quản lý vòng đời container một cách tự động và chuẩn hóa
                sh '''
                    docker compose down || true
                    docker compose up -d --build
                '''
            }
        }

        stage('Health Check') {
            steps {
                echo "===> [STAGE 4] Kiểm tra trạng thái hoạt động của Container ${APP_NAME}..."
                sh 'docker ps --filter "name=${APP_NAME}" --filter "status=running"'
            }
        }
    }

    post {
        success {
            echo "🚀 [DEPLOY SUCCESS] Ứng dụng ${APP_NAME} đã được triển khai tự động thành công rực rỡ!"
            echo "👉 Truy cập ngay tại: http://<IP_VPS>:${DOCKER_PORT}"
        }
        failure {
            echo "❌ [DEPLOY FAILED] Pipeline thất bại! Vui lòng kiểm tra Console Output của Jenkins và Docker Engine trên VPS."
        }
    }
}
