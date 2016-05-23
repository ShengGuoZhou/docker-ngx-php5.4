sudo docker run -d --name nginx \
    -p 80:80 \
    -p 443:443 \
    -p 3306:3306 \
    -p 11211:11211 \
    -v ~/dev/:/var/www/:rw \
    -v ~/docker-mount/nginx/vhosts/:/etc/nginx/conf.d/:rw \
    danielmeneses/nginx-php5.4

# -v ~/docker-mount/mysql-data/:/var/lib/mysql:rw \
# -p 3000:3000 \
sudo docker build -t danielmeneses/nginx-php5.4 .
