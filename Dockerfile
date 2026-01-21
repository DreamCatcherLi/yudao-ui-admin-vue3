# frontend/Dockerfile
# 第一阶段：构建Vue应用
FROM registry.cn-beijing.aliyuncs.com/liam_test/node:20-alpine AS builder

# 设置工作目录
WORKDIR /app

# 安装 pnpm
RUN npm install -g pnpm

# 复制依赖文件
COPY package.json pnpm-lock.yaml ./

# 安装依赖
# 使用国内镜像源加速
RUN pnpm config set registry https://registry.npmmirror.com
RUN pnpm install --frozen-lockfile

# 复制项目文件
COPY . .

# 定义构建环境参数，默认为 prod
ARG env=prod
# 构建应用
RUN pnpm run build:${env}

# 第二阶段：构建最终镜像
FROM registry.cn-beijing.aliyuncs.com/liam_test/nginx:alpine

# 设置时区
RUN apk add --no-cache tzdata && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone

# 将第一阶段构建的dist目录复制到Nginx的默认静态文件目录
COPY --from=builder /app/dist /usr/share/nginx/html
# 用我们自定义的nginx配置替换默认配置
COPY nginx.conf /etc/nginx/nginx.conf

# 暴露端口
EXPOSE 80
# 以非守护进程方式启动Nginx (对容器运行至关重要)
CMD ["nginx", "-g", "daemon off;"]