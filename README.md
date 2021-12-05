# apache2 php5
from php:5.6.40-apache basis debian stretch  
fitur : apache2 php5 mysql mssql phalcon gd zip  

## catatan  
docker build --tag nimdasx/sf-php-5 .  
docker push nimdasx/sf-php-5  

## run
docker run -d -p 80:80 -v /Users/sofyan/Dev/php:/var/www/html --name terserah nimdasx/sf-php-5  

## sql server konfig di zendframework1  
sipkd.adapter = PDO_MSSQL  
sipkd.params.pdoType = dblib  