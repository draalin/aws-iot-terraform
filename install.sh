#! /bin/bash
cd /home/ubuntu
sudo apt-get update
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt install nodejs -y
sudo apt install awscli -y
cd app
npm install
cat <<EOT >> .env
REACT_APP_IDENTITY_POOL_ID='${REACT_APP_IDENTITY_POOL_ID}'
REACT_APP_REGION='${REACT_APP_REGION}'
REACT_APP_USER_POOL_ID='${REACT_APP_USER_POOL_ID}'
REACT_APP_USER_POOL_WEB_CLIENT_ID='${REACT_APP_USER_POOL_WEB_CLIENT_ID}'
REACT_APP_MQTT_ID='a2os967qpqx1e5-ats'
EOT
npm start