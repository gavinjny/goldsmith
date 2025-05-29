echo 'Updating packages...'
sudo apt-get update -y
sudo apt-get upgrade -y

echo 'Setting timezone to America/New_York (Eastern)...'
sudo timedatectl set-timezone America/New_York
echo 'Done with patching and timezone setup.'