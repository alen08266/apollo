#!/bin/sh

# apollo config db info
spring.datasource.url = jdbc:mysql://rm-bp149t3or0eb470956o.mysql.rds.aliyuncs.com:3306/apolloconfigdb?useUnicode=true&characterEncoding=UTF-8&allowMultiQueries=true&zeroDateTimeBehavior=convertToNull
spring.datasource.username = saas1
spring.datasource.password = olymtech1

# apollo portal db info
spring.datasource.url = jdbc:mysql://rm-bp149t3or0eb470956o.mysql.rds.aliyuncs.com:3306/apolloportaldb?useUnicode=true&characterEncoding=UTF-8&allowMultiQueries=true&zeroDateTimeBehavior=convertToNull
spring.datasource.username = saas1
spring.datasource.password = olymtech1

# meta server url, different environments should have different meta server addresses
dev_meta=http://120.27.151.176:8081

META_SERVERS_OPTS="-Ddev_meta=$dev_meta -Dfat_meta=$fat_meta -Duat_meta=$uat_meta -Dpro_meta=$pro_meta"

# =============== Please do not modify the following content =============== #
# go to script directory
cd "${0%/*}"

cd ..

# package config-service and admin-service
echo "==== starting to build config-service and admin-service ===="

mvn clean package -DskipTests -pl apollo-configservice,apollo-adminservice -am -Dapollo_profile=github -Dspring_datasource_url=$apollo_config_db_url -Dspring_datasource_username=$apollo_config_db_username -Dspring_datasource_password=$apollo_config_db_password

echo "==== building config-service and admin-service finished ===="

echo "==== starting to build portal ===="

mvn clean package -DskipTests -pl apollo-portal -am -Dapollo_profile=github,auth -Dspring_datasource_url=$apollo_portal_db_url -Dspring_datasource_username=$apollo_portal_db_username -Dspring_datasource_password=$apollo_portal_db_password $META_SERVERS_OPTS

echo "==== building portal finished ===="
