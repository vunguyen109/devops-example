# Base image Nginx Alpine siêu nhẹ và bảo mật cao
FROM nginx:alpine

# Xóa các file mặc định của Nginx nếu có và sao chép source mã tĩnh
COPY index.html /usr/share/nginx/html/index.html

# Expose cổng 80 nội bộ của container
EXPOSE 80

# Chạy Nginx ở chế độ foreground (không daemonize) để giữ container luôn active
CMD ["nginx", "-g", "daemon off;"]
