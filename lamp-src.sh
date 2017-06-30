#!/bin/bash

yum -y groupinstall "Development tools"
yum -y install expat-devel

wget http://mirror.bit.edu.cn/apache//httpd/httpd-2.4.26.tar.gz

wget http://mirror.bit.edu.cn/apache//apr/apr-util-1.6.0.tar.gz
wget http://mirror.bit.edu.cn/apache//apr/apr-1.6.2.tar.gz


tar -xf apr-1.6.2.tar.gz
cd apr-1.6.2
make 
make install
cd ..




tar -xvf apr-util-1.6.0.tar.gz
cd apr-util-1.6.0
./configure --prefix=/usr/local/apr-util --with-apr=/usr/local/apr/
make
make install
cd ..

tar -xf httpd-2.4.26.tar.gz
cd httpd-2.4.26
./configure --prefix=/usr/local/apache \
	--sysconfdir=/etc/httpd  \
	--enable-so --enable-rewrite \
	--enable-cgid \
	--enable-cgi \
	--enable-modules=most \
	--enable-mods-shared=most \
	--enable-mpms-shared=all \
	--with-apr=/usr/local/apr \
	--with-apr-util=/usr/local/apr-util
make
make install

echo 'PidFile "/var/run/httpd.pid"' >> /etc/httpd/httpd.conf
sed -i '/mpm_event_module/s/LoadModule/#&/' /etc/httpd/httpd.conf
sed -i '/mpm_prefork_module/s/^#//' /etc/httpd/httpd.conf

chmod +x httpd
cp httpd /etc/init.d/

chkconfig --add httpd
chkconfig on httpd

