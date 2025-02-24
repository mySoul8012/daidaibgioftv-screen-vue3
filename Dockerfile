# 使用官方 Node.js 镜像作为构建阶段的基础镜像
FROM node:lts-alpine AS build-stage

# 设置工作目录
WORKDIR /app

# 克隆项目仓库
RUN apk add --no-cache git && \
    git clone https://github.com/daidaibg/IofTV-Screen-Vue3.git . && \
    rm -rf .git

# 安装依赖
RUN npm install

# 构建项目
RUN npm run build

# 使用官方 Nginx 镜像作为生产阶段的基础镜像
FROM nginx:stable-alpine AS production-stage

# 将构建的文件从前一阶段复制到 Nginx 的默认静态文件目录
COPY --from=build-stage /app/dist /usr/share/nginx/html

# 暴露端口
EXPOSE 80

# 启动 Nginx
CMD ["nginx", "-g", "daemon off;"]
