@echo off

rem apollo config db info
set apollo_config_db_url="jdbc:mysql://rm-bp149t3or0eb470956o.mysql.rds.aliyuncs.com:3306/apolloconfigdb?useUnicode=true&characterEncoding=UTF-8&allowMultiQueries=true&zeroDateTimeBehavior=convertToNull"
set apollo_config_db_username="saas1"
set apollo_config_db_password="olymtech1"

rem apollo portal db info
set apollo_portal_db_url="jdbc:mysql://rm-bp149t3or0eb470956o.mysql.rds.aliyuncs.com:3306/apolloportaldb?useUnicode=true&characterEncoding=UTF-8&allowMultiQueries=true&zeroDateTimeBehavior=convertToNull"
set apollo_portal_db_username="saas1"
set apollo_portal_db_password="olymtech1"

rem meta server url, different environments should have different meta server addresses
set dev_meta="http://120.27.151.176:8081"

set META_SERVERS_OPTS=-Ddev_meta=%dev_meta% -Dfat_meta=%fat_meta% -Duat_meta=%uat_meta% -Dpro_meta=%pro_meta%

rem =============== Please do not modify the following content =============== 
rem go to script directory
cd "%~dp0"

cd ..

rem package config-service and admin-service
echo "==== starting to build config-service and admin-service ===="

call mvn clean package -DskipTests -pl apollo-configservice,apollo-adminservice -am -Dapollo_profile=github -Dspring_datasource_url=%apollo_config_db_url% -Dspring_datasource_username=%apollo_config_db_username% -Dspring_datasource_password=%apollo_config_db_password%

echo "==== building config-service and admin-service finished ===="

echo "==== starting to build portal ===="

call mvn clean package -DskipTests -pl apollo-portal -am -Dapollo_profile=github,auth -Dspring_datasource_url=%apollo_portal_db_url% -Dspring_datasource_username=%apollo_portal_db_username% -Dspring_datasource_password=%apollo_portal_db_password% %META_SERVERS_OPTS%

echo "==== building portal finished ===="

pause
