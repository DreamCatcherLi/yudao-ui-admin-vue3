# 生产环境使用 Nginx
FROM nginx:alpine

# 复制本地构建好的文件到nginx目录
COPY dist-test /usr/share/nginx/html

# 复制nginx配置
COPY nginx.conf /etc/nginx/nginx.conf

# 暴露端口
EXPOSE 80

# 启动nginx
CMD ["nginx", "-g", "daemon off;"]