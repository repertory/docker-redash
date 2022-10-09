FROM alpine:3.6

ENV C_FORCE_ROOT true

ENV REDASH_DATE_FORMAT YYYY-MM-DD
ENV REDASH_FEATURE_ALLOW_ALL_TO_EDIT false
ENV REDASH_FEATURE_SHOW_PERMISSIONS_CONTROL true
ENV REDASH_FEATURE_ALLOW_CUSTOM_JS_VISUALIZATIONS true
ENV REDASH_VERSION_CHECK false

ENV REDASH_MAIL_SERVER smtp-mail.outlook.com
ENV REDASH_MAIL_PORT 587
ENV REDASH_MAIL_USE_TLS true
ENV REDASH_MAIL_USE_SSL false
ENV REDASH_MAIL_USERNAME serve-notice@outlook.com
ENV REDASH_MAIL_PASSWORD notice12345678
ENV REDASH_MAIL_DEFAULT_SENDER serve-notice@outlook.com

RUN sed -i -e 's~dl-cdn.alpinelinux.org~mirrors.aliyun.com~g' /etc/apk/repositories
RUN apk --no-cache add bash build-base g++ make autoconf python-dev py2-pip tzdata nodejs nodejs-npm git pwgen \
    mariadb-dev postgresql-dev libffi-dev linux-headers musl-dev libressl-dev cyrus-sasl-dev libpq && \
    yes | cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

ADD freetds-0.95.95.tar.gz /opt/
ADD redash-3.0.0.tar.gz /

RUN mv /redash-3.0.0 /app && \
    cd /opt/freetds-0.95.95 && \
    ./configure && make && make install && \
    rm -rf /opt/freetds-0.95.95

WORKDIR /app

# 汉化处理
COPY data/redash/client/app /app/client/app
COPY data/redash/redash /app/redash
COPY data/redash/package.json /app/package.json
COPY data/redash/package-lock.json /app/package-lock.json

RUN pip install --upgrade pip
RUN pip --no-cache-dir install setuptools-git==1.2 rsa==3.4.2 Cython==0.25.2 \
    -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
RUN pip --no-cache-dir install \
    -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com \
    -r requirements.txt -r requirements_dev.txt -r requirements_all_ds.txt

RUN npm config set registry https://repo.huaweicloud.com/repository/npm/
RUN npm config set sass_binary_site https://repo.huaweicloud.com/node-sass

RUN make && \
    cp -r ./client/app/assets/fonts/roboto ./client/dist/fonts/ && \
    rm -rf node_modules && npm cache clear

RUN ln -s /usr/bin/celery /usr/local/bin/celery && \
    ln -s /usr/bin/gunicorn /usr/local/bin/gunicorn

ENTRYPOINT ["/app/bin/docker-entrypoint"]
