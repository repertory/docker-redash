FROM redash/redash:1.0.1.b2843
MAINTAINER wangdong <mail@wangdong.io>

USER root

# 常规配置
ENV REDASH_DATE_FORMAT YYYY-MM-DD
ENV REDASH_COOKIE_SECRET 123456
ENV REDASH_REDIS_URL redis://127.0.0.1:6379/0
ENV REDASH_DATABASE_URL postgresql://postgres:postgres@127.0.0.1:5432/postgres
ENV QUEUES queries,scheduled_queries,celery
ENV WORKERS_COUNT 2
ENV REDASH_LOG_LEVEL INFO
ENV PYTHONUNBUFFERED 0
ENV C_FORCE_ROOT true

# 邮箱配置
ENV REDASH_MAIL_SERVER smtp-mail.outlook.com
ENV REDASH_MAIL_PORT 587
ENV REDASH_MAIL_USE_TLS true
ENV REDASH_MAIL_USE_SSL false
ENV REDASH_MAIL_USERNAME serve-notice@outlook.com
ENV REDASH_MAIL_PASSWORD 112233..
ENV REDASH_MAIL_DEFAULT_SENDER serve-notice@outlook.com

# 服务安装
RUN apt-get update && \
    apt-get -y install postgresql redis-server language-pack-zh-hant language-pack-zh-hans vim && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 国内构建时去掉下面注释，否则容易失败
# RUN npm install -g nrm --registry=https://registry.npm.taobao.org && \
#     nrm use taobao && \
#     echo 'sass_binary_site=https://npm.taobao.org/mirrors/node-sass/' >> ~/.npmrc && \
#     npm cache clean

# 汉化处理
COPY client /app/client
COPY redash /app/redash
COPY templates /app/redash/templates
COPY bin /app/bin
RUN npm install && npm run build && rm -rf node_modules && npm cache clean

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