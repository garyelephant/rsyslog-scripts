## Install rsyslog with omelasticsearch.
## omelasticsearch enables rsyslog to push logs to elasticsearch, a distributed search engine.
## see http://www.rsyslog.com/doc/v8-stable/configuration/modules/omelasticsearch.html
## This installation use yum to manage packages.

## add rsyslog repo
WORK_DIR=$(pwd)
cd /etc/yum.repos.d
wget http://rpms.adiscon.com/v8-stable/rsyslog.repo -O rsyslog.repo

cd $WORK_DIR
mkdir rsyslog-install
cd rsyslog-install

# check rsyslog version
# rsyslog supports kafka from v8.7.0
old_rsyslog_ver=$(rsyslogd -version |head -n 1 | awk '{print $2}')

## install rsyslog dependency: libestr
yum install -y libestr-devel.x86_64

## install rsyslog dependency: libee
yum install -y libee-devel.x86_64

## install rsyslog dependency: json-c
yum install -y json-c-devel.x86_64

## install rsyslog denpendency: uuid
yum install -y libuuid-devel

## install rsyslog denpendency: liblogging-stdlog
yum install -y liblogging-devel.x86_64

## install rsyslog denpendency: rst2man
yum install -y python-docutils

## install libcurl for omelasticsearch
yum install -y libcurl-devel.x86_64

cd ..
## install rsyslog
wget http://www.rsyslog.com/files/download/rsyslog/rsyslog-8.8.0.tar.gz -O rsyslog-8.8.0.tar.gz
tar zxvf rsyslog-8.8.0.tar.gz
export PKG_CONFIG_PATH=/usr/lib64/pkgconfig:/lib64/pkgconfig/
old_executable_path=$(which rsyslogd)
executable_dir=$(dirname "$old_executable_path")
cd rsyslog-8.8.0
./configure --sbindir=$executable_dir --libdir=/usr/lib64 --enable-elasticsearch
make
make install

## show installation result:
new_rsyslog_ver=$(rsyslogd -version |head -n 1 | awk '{print $2}')
echo "Old rsyslogd version: "$old_rsyslog_ver
echo "New rsyslogd version: "$new_rsyslog_ver
echo "Executable: " $(which rsyslogd)

## References:
## http://www.rsyslog.com/doc/master/installation/install_from_source.html
## http://bigbo.github.io/pages/2015/01/21/syslog_kafka/
## http://blog.oldzee.com/?tag=rsyslog
## http://www.rsyslog.com/newbie-guide-to-rsyslog/
