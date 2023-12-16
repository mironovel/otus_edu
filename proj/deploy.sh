#!/bin/bash
sed -i "/#\$nrconf{restart} = 'i';/s/.*/\$nrconf{restart} = 'a';/" /etc/needrestart/needrestart.conf
#Update
apt update #&& apt upgrade -y
#setup Nginx & Apache
apt install nginx apache2 -y #--fix-missing
cp -r ./apache2/html /var/www/
cp ./apache2/sites.conf /etc/apache2/sites-enabled/
cp ./apache2/ports.conf /etc/apache2/
systemctl restart apache2
rm /etc/nginx/sites-enabled/default
cp ./nginx/*.conf /etc/nginx/conf.d/
systemctl restart nginx
#MySQL
apt install mysql-server-8.0 -y
#mysql -u root -e "USE mysql;CREATE USER admin@'%' IDENTIFIED BY 'P@ssw0rd';GRANT ALL PRIVILEGES ON *.* TO admin@'%';FLUSH PRIVILEGES;" select host,user,plugin from user;
mysql -u root -e "USE mysql;CREATE USER repl@'%' IDENTIFIED BY 'P@ssw0rd';GRANT REPLICATION SLAVE ON *.* TO repl@'%';FLUSH PRIVILEGES;"
service mysql restart
#prometheus
apt install prometheus prometheus-node-exporter prometheus-nginx-exporter -y
cp ./prometheus/prometheus.yml /etc/prometheus/
systemctl restart prometheus.service
#Docker + Grafana
apt install docker.io -y
docker run -d --name=grafana -p 3000:3000 grafana/grafana-enterprise
#curl -o grafana.deb https://mirror.yandex.ru/mirrors/packages.grafana.com/enterprise/deb/pool/main/g/grafana-enterprise/grafana-enterprise_10.2.0_amd64.deb
