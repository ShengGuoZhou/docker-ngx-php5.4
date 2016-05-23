#!/bin/bash

# start services
service mysqld restart;
# handle mysql access
# touch /container-scripts/mysql-init.log;
# mysqladmin -u root -h localhost password 'root' > /container-scripts/mysql-init.log;
mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY ''" > /container-scripts/mysql-init.log;
mysql -u root -e "FLUSH PRIVILEGES" >> /container-scripts/mysql-init.log;

# other services
supervisord;
service php-fpm restart;
service nginx restart;
service memcached restart;
# redis is last because is not started as a service
redis-server;

# systemctl start php-fpm;
# systemctl enable php-fpm;
