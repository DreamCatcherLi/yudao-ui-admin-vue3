# frontend/Dockerfile
# 第一阶段：构建Vue应用
FROM node:16-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install --registry=https://registry.npmmirror.com # 可使用国内镜像加速
COPY . .
RUN npm run build

# 第二阶段：构建最终镜像
FROM nginx:alpine
# 将第一阶段构建的dist目录复制到Nginx的默认静态文件目录
COPY --from=builder /app/dist /usr/share/nginx/html
# 用我们自定义的nginx配置替换默认配置
COPY nginx.conf /etc/nginx/nginx.conf
# 暴露端口
EXPOSE 80
# 以非守护进程方式启动Nginx (对容器运行至关重要)
CMD ["nginx", "-g", "daemon off;"]