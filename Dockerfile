FROM redash/redash:1.0.1.b2833
MAINTAINER wangdong <mail@wangdong.io>

USER root

# 常规配置
ENV REDASH_DATE_FORMAT YYYY-MM-DD
ENV REDASH_REDIS_URL redis://127.0.0.1:6379/0
ENV REDASH_DATABASE_URL postgresql://postgres:postgres@127.0.0.1:5432/postgres

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
    apt-get -y install postgresql redis-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 汉化处理
COPY client /app/client
COPY templates /app/redash/templates
COPY bin /app/bin

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