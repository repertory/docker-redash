# redash汉化版

**基于 v1.0.1 版本**

> Dockerfile: https://code.aliyun.com/wangdong/docker-redash/raw/master/Dockerfile

```
docker pull registry.cn-hangzhou.aliyuncs.com/wangdong/redash
```

## 启动方法

```
docker run --name redash -p 5000:5000 registry.cn-hangzhou.aliyuncs.com/wangdong/redash start
```

## 初始化配置

浏览器访问 http://127.0.0.1:5000/setup 进行设置

## 其他数据库

> 默认先初始化数据库

```
docker run --name redash -p 5000:5000 \
-e REDASH_HOST=http://127.0.0.1:5000 \
-e REDASH_DATABASE_URL=postgresql://postgres:postgres@127.0.0.1:5432/postgres \
-e REDASH_REDIS_URL=redis://127.0.0.1:6379/0 \
registry.cn-hangzhou.aliyuncs.com/wangdong/redash start
```

> 不初始化数据库

```
docker run --name redash -p 5000:5000 \
-e REDASH_HOST=http://127.0.0.1:5000 \
-e REDASH_DATABASE_URL=postgresql://postgres:postgres@127.0.0.1:5432/postgres \
-e REDASH_REDIS_URL=redis://127.0.0.1:6379/0 \
registry.cn-hangzhou.aliyuncs.com/wangdong/redash run
```

## 邮箱配置

```
docker run --name redash -p 5000:5000 \
-e REDASH_HOST=http://127.0.0.1:5000 \
-e REDASH_MAIL_SERVER=smtp-mail.outlook.com \
-e REDASH_MAIL_PORT=587 \
-e REDASH_MAIL_USE_TLS=true \
-e REDASH_MAIL_USE_SSL=false \
-e REDASH_MAIL_USERNAME=yourname@outlook.com \
-e REDASH_MAIL_PASSWORD=123456 \
-e REDASH_MAIL_DEFAULT_SENDER=yourname@outlook.com \
registry.cn-hangzhou.aliyuncs.com/wangdong/redash start
```