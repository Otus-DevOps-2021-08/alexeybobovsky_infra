#!/bin/bash
echo -e "#!/bin/bash\ncd /home/ubuntu/reddit\npuma -d\n" > /home/ubuntu/reddit.sh
echo -e "[Unit]\nDescription=My_personal_reddit\nAfter=network.target\n[Service]\nType=forking\nExecStart=/home/ubuntu/reddit.sh\nRestart=always\n[Install]\nWantedBy=multi-user.target\n" | sudo tee /etc/systemd/system/puma.service
chmod +x /home/ubuntu/reddit.sh
sudo systemctl daemon-reload
sudo apt-get update
sudo apt-get install -y git
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install
sudo systemctl enable puma.service
