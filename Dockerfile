FROM redash/redash:1.0.1.b2843
MAINTAINER wangdong <mail@wangdong.io>

USER root

# 常规配置
ENV REDASH_DATE_FORMAT YYYY-MM-DD
ENV REDASH_REDIS_URL redis://127.0.0.1:6379/0
ENV REDASH_DATABASE_URL postgresql://postgres:postgres@127.0.0.1:5432/postgres

# 服务安装
RUN apt-get update && \
    apt-get -y install postgresql redis-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 汉化处理
COPY client /app/client
COPY templates /app/redash/templates
COPY bin /app/bin
RUN npm install -g nrm --registry=https://registry.npm.taobao.org && \
    nrm use taobao && \
    echo 'sass_binary_site=https://npm.taobao.org/mirrors/node-sass/' >> ~/.npmrc && \
    npm install && npm run build && rm -rf node_modules

# 配置修改
RUN sed -i \
        -e 's~^bind 127.0.0.1~#bind 127.0.0.1~g' \
    /etc/redis/redis.conf
RUN sed -i \
        -e 's~peer$~trust~g' \
        -e 's~md5$~trust~g' \
    /etc/postgresql/9.5/main/pg_hba.conf

WORKDIR /app
ENTRYPOINT ["/app/bin/docker-entrypoint"]