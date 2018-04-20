# docker-redash

> 基于alpine linux的re:dash v3.0.0

## 初始化

```
# 初始化数据
docker-compose run --rm server create_db

# 启动
docker-compose up
```

## 筛选

|字段|说明|
|----|----|
|::filter|单选框筛选|
|::multiFilter|多选框筛选|
|::keywordFilter|关键字模糊筛选|
|::betweenFilter|字段范围筛选|

> 使用方法

```
SELECT count(1) AS `人数::betweenFilter` FROM users
```
