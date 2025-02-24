# 基于现有的 daidaibg/ioftv-screen-vue3 镜像
FROM daidaibg/ioftv-screen-vue3

# 设置工作目录
WORKDIR /app

# 复制您的自定义文件到工作目录
COPY . .

# 安装依赖（如果有新的依赖）
RUN npm install

# 构建项目
RUN npm run build

# 暴露端口
EXPOSE 80

# 启动应用
CMD ["npm", "run", "serve"]
