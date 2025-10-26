sudo apt update
sudo apt install rfkill -y
sudo systemctl enable bluetooth --now
sudo source ~/.bashrc
sudo reboot
