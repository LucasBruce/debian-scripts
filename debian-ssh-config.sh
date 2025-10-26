ssh-keygen -t ed25519 -C "lucasmatheusbruce@gmail.com"

ssh-add ~/.ssh/id_ed25519

ssh -T git@github.com

git config --global user.email "lucasmatheusbruce@gmail.com"

git config --global user.name "LucasBruce"
