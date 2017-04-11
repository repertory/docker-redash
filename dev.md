# npm国内加速

```
npm install -g nrm --registry=https://registry.npm.taobao.org
nrm use taobao
echo 'sass_binary_site=https://npm.taobao.org/mirrors/node-sass/' >> ~/.npmrc
```

# 本地文件编译

```
npm install
npm run watch
```

# 本地文件调试

```
sudo docker run --rm -p 5000:5000 -v ~/www/docker-redash/redash:/app/redash -v ~/www/docker-redash/client:/app/client registry.cn-hangzhou.aliyuncs.com/wangdong/redash start
```

# 浏览器访问

http://127.0.0.1:5000