
## 使用 Docker 部署

您可以使用 Docker 快速部署此项目，以下是详细步骤：

### 1. 构建 Docker 镜像

首先，在项目根目录下创建一个名为 `Dockerfile` 的文件，内容如下：

```dockerfile
# 使用官方 Node.js 镜像作为构建阶段的基础镜像
FROM node:lts-alpine AS build-stage

# 设置工作目录
WORKDIR /app

# 复制 package.json 和 package-lock.json（如果有）文件
COPY package*.json ./

# 安装依赖
RUN npm install

# 复制项目的所有文件到工作目录
COPY . .

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
```


然后，打开终端，导航到项目根目录，运行以下命令构建 Docker 镜像：

```bash
docker build -t your-project-name .
```


请将 `your-project-name` 替换为您希望的镜像名称。

### 2. 运行 Docker 容器

构建完成后，运行以下命令启动容器：

```bash
docker run -d -p 80:80 your-project-name
```


此命令将在后台运行容器，并将容器的 80 端口映射到主机的 80 端口。您可以在浏览器中通过 `http://localhost` 访问该应用。

### 注意事项

- **端口冲突**：如果主机的 80 端口已被占用，您可以修改映射的端口，例如将主机的 8080 端口映射到容器的 80 端口：

  ```bash
  docker run -d -p 8080:80 your-project-name
  ```

  
然后通过 `http://localhost:8080` 访问应用。

- **数据持久化**：如果需要在容器外部保存数据，建议使用 Docker 卷（volumes）或将主机目录挂载到容器内。

- **生产环境**：在生产环境中，建议使用 `docker-compose` 或 Kubernetes 等工具进行容器编排，以便更好地管理和扩展应用。

有关 Docker 的更多信息，请参考 [Docker 官方文档](https://docs.docker.com/)。
