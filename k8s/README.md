Для запуска необходимо иметь файлы ключей ssh
~/.ssh/id_rsa
~/.ssh/id_rsa.pub
На файлах не должно стоять паролей

из папки terraform
terraform init
terraform apply

из папаки ansible
ansible-playbook node.yml

Далее заходим на node-0 смотри файл invtntory
на нем
cd /srv/kubspray
sudo  ansible-playbook -u 'ubuntu' -i inventory/sample/hosts.ini cluster.yml -b --key-file ~/.ssh/id_rsa
mkdir ~/.kube
sudo cp /etc/kubernetes/admin_conf ~/.kube/config 
