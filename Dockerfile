FROM centos:6
MAINTAINER wangdong <mail@wangdong.io>

ENV PATH $PATH:/usr/pgsql-9.6/bin

# 常规配置
ENV REDASH_HOST http://127.0.0.1:5000
ENV REDASH_DATE_FORMAT YYYY-MM-DD
ENV REDASH_COOKIE_SECRET 903463972b275f53104788f0f31f851f7ac8a928
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

# 运行环境配置
RUN yum install -y epel-release gcc gcc-c++ git wget && \
    rpm -Uvh https://centos6.iuscommunity.org/ius-release.rpm && \
    rpm -Uvh https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-6-x86_64/pgdg-centos96-9.6-3.noarch.rpm && \
    yum install -y postgresql96-devel mysql-devel cyrus-sasl-devel freetds-devel libffi-devel pwgen openssl-devel \
    redis32u postgresql96-server python27-pip python27-devel && \
    service postgresql-9.6 initdb && \
    sed -i -e 's~peer$~trust~g' -e 's~ident$~trust~g' /var/lib/pgsql/9.6/data/pg_hba.conf && \
    ln -s /usr/bin/python2.7 /usr/local/bin/python && \
    ln -s /usr/bin/pip2.7 /usr/local/bin/pip && \
    yum clean all && rm -rf /tmp/yum*

# 安装node.js
RUN wget https://nodejs.org/dist/v7.8.0/node-v7.8.0-linux-x64.tar.gz && \
    tar -zxf node-v7.8.0-linux-x64.tar.gz -C /usr/local/ --strip-components 1 && \
    rm -f node-v7.8.0-linux-x64.tar.gz && \
#    npm install -g nrm --registry=https://registry.npm.taobao.org && \
#    nrm use taobao && \
#    echo 'sass_binary_site=https://npm.taobao.org/mirrors/node-sass/' >> ~/.npmrc && \
    npm cache clean && rm -rf /tmp/npm*

# 部署软件源码
RUN git clone -b v1.0.1  https://github.com/getredash/redash.git /app
WORKDIR /app

# 汉化处理
COPY client /app/client
COPY redash /app/redash
COPY docker-entrypoint /app/bin/docker-entrypoint

# 依赖安装
RUN pip install -r requirements.txt -r requirements_dev.txt -r requirements_all_ds.txt && \
    make && \
    npm cache clean && rm -rf /tmp/npm*

ENTRYPOINT ["/app/bin/docker-entrypoint"]