apt-get update -y
apt full-upgrade -y
cd /home/brand/smartboi/docker
docker compose pull
docker compose up -d
sleep 20
shutdown -r now