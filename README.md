# phalcon 3 php apache
from php:5.6.40-apache basis debian stretch  

## catatan  
docker build --tag nimdasx/sf-php-5 .  
docker run -d -p 80:80 -v d:/dev/php:/var/www/html --name terserah nimdasx/sf-php-5  
docker push nimdasx/sf-php-5  

## sql server konfig di zendframework1  
sipkd.adapter = PDO_MSSQL  
sipkd.params.pdoType = dblib  