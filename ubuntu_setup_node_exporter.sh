#!/bin/bash
################################
# Description: Install NodeExporter for Prometheus
# Date: 26/02/2019
# Author: Jose Ramon Mañes
# TODO: 
# Create an Ansible playbook  
################################
sudo useradd node_exporter -s /sbin/nologin
cd /opt
wget https://github.com/prometheus/node_exporter/releases/download/v0.17.0/node_exporter-0.17.0.linux-amd64.tar.gz
################################
tar -xvzf node_exporter-*.*-amd64.tar.gz
mv /opt/node_exporter-0.17.0.linux-amd64/ /opt/node_exporter
cp node_exporter/node_exporter /usr/sbin/
rm /opt/node_exporter-*.*-amd64.tar.gz
################################
if [ ! -f /etc/systemd/system/node_exporter.service ];then

touch /etc/systemd/system/node_exporter.service
cat <<EOF >>/etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter

[Service]
User=node_exporter
#EnvironmentFile=/etc/sysconfig/node_exporter
ExecStart=/usr/sbin/node_exporter --web.listen-address=localhost:9111

[Install]
WantedBy=multi-user.target
EOF

fi
################################
sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl status node_exporter
