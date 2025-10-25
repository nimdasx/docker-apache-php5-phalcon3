```
# build dan push ke github
docker build --tag ghcr.io/nimdasx/apache-php5-phalcon3 .
docker push ghcr.io/nimdasx/apache-php5-phalcon3

# build dan push ke docker hub
docker build --tag nimdasx/apache-php5-phalcon3 .
docker push nimdasx/apache-php5-phalcon3

# pakai buildx
docker buildx build --platform linux/amd64 --tag nimdasx/apache-php5-phalcon3 --push .

# sql server konfig di zendframework1  
sipkd.adapter = PDO_MSSQL  
sipkd.params.pdoType = dblib  

dulu image ini namanya nimdasx/sf-php-5
```