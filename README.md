# 🚀 Techzen Academy - Bài Thực Hành Jenkins CI/CD (Buổi 8)

Repository mẫu chuẩn hóa dành riêng cho học viên thực hành xây dựng luồng **Declarative Pipeline** tự động hóa với **Jenkins**, **Docker** và **Nginx** trên môi trường VPS / Máy ảo VirtualBox.

---

## 📁 Cấu Trúc Dự Án

```text
.
├── index.html          # Landing page hiển thị trạng thái và thông số hệ thống
├── Dockerfile          # Đóng gói ứng dụng web tĩnh với Nginx Alpine siêu nhẹ
├── docker-compose.yml  # File điều phối container chuẩn hóa dịch vụ & port map
├── Jenkinsfile         # Script CI/CD Declarative Pipeline 4 stages chuẩn
├── .dockerignore       # Tối ưu Docker build context
└── README.md           # Tài liệu hướng dẫn thực hành
```

---

## 🛠 Hướng Dẫn Thực Hành 3 Bước

### Bước 1: Khởi tạo và Đưa mã nguồn lên GitHub cá nhân

1. Mở Terminal tại thư mục dự án và khởi tạo Git repository:
   ```bash
   git init
   git add .
   git commit -m "feat: init devops-example project for jenkins lab"
   git branch -M main
   ```
2. Tạo một repository mới trên GitHub (ví dụ: `devops-example`).
3. Liên kết remote và đẩy code lên:
   ```bash
   git remote add origin https://github.com/vunguyen109/devops-example.git
   git push -u origin main
   ```

---

### Bước 2: Cấu hình Pipeline Job trên Jenkins

Đăng nhập vào Jenkins Web UI (`http://<IP_VPS>:8080`) và thực hiện tạo Job mới:

1. Nhấn **New Item** &rarr; Đặt tên `techzen-cicd-pipeline` &rarr; Chọn kiểu **Pipeline** &rarr; Nhấn **OK**.
2. Thêm Credential GitHub Token vào Jenkins:
   - Vào **Manage Jenkins** &rarr; **Credentials** &rarr; **System** &rarr; **Global credentials**.
   - Thêm credential kiểu **Username with password** (hoặc **Secret text**).
   - Đặt ID là: `github-token`.
3. Cấu hình kịch bản Pipeline (chọn 1 trong 2 cách):

   - **Cách 1: Pipeline Script (Dán trực tiếp - Nhanh nhất)**:
     - Tại mục **Pipeline**, chọn Definition: `Pipeline script`.
     - Sao chép toàn bộ nội dung từ file `Jenkinsfile` dán vào ô Script.
     - *Lưu ý*: Thay `https://github.com/vunguyen109/devops-example.git` thành URL GitHub thật của bạn.
   
   - **Cách 2: Pipeline script from SCM (Chuẩn Production)**:
     - Chọn Definition: `Pipeline script from SCM`.
     - SCM: `Git`.
     - Repository URL: `https://github.com/vunguyen109/devops-example.git`.
     - Credentials: chọn `github-token`.
     - Branch Specifier: `*/main`.
     - Script Path: `Jenkinsfile`.

4. Nhấn **Save** và bấm **Build Now** để khởi chạy Pipeline.

---

### Bước 3: Kiểm tra và Nghiệm thu Kết Quả

1. Quan sát trạng thái các Stages trên Jenkins:
   - `Checkout Source Code` &rarr; `Build Docker Image` &rarr; `Deploy Container on VPS` &rarr; `Health Check`.
   - Tất cả chuyển sang màu **Xanh (Success)** 🟢.
2. Mở trình duyệt web và truy cập địa chỉ ứng dụng:
   ```text
   http://<IP_VPS>:8081
   hoặc
   http://localhost:8081 (nếu chạy local máy ảo có port forwarding)
   ```
3. Màn hình giao diện **Techzen Academy - DevOps Fundamentals** xuất hiện với trạng thái:
   `Deployment Status: SUCCESS (Automated by Jenkins CI/CD)`.

---

## ⚡ (Tùy chọn) Chạy Thử Nhanh Bằng Docker Compose Tại Local/VPS

Nếu bạn muốn kiểm tra nhanh ứng dụng mà không cần qua Jenkins:

```bash
# Khởi động dịch vụ ở chế độ nền (background) và tự động build
docker compose up -d --build

# Kiểm tra log container
docker compose logs -f

# Dừng và dọn dẹp container
docker compose down
```
Truy cập: `http://localhost:8081` hoặc `http://<IP_VPS>:8081`.

