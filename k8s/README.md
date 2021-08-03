Для запуска необходимо иметь файлы ключей ssh
~/.ssh/id_rsa
~/.ssh/id_rsa.pub
На файлах не должно стоять паролей

из папки terraform
terraform init
terraform apply

из папаки ansible
ansible-playbook node.yml


На каждой ноде из файла inventory выполнить:
sudo mkdir -p /mnt/disks/vdc1

sudo echo 'type=83' | sudo sfdisk /dev/vdb
sudo echo 'type=83' | sudo sfdisk /dev/vdc

sudo mkfs.ext4 /dev/vdb1
sudo mkfs.ext4 /dev/vdc1

sudo mount /dev/vdb1 /mnt/disks/vdb1
sudo mount /dev/vdc1 /mnt/disks/vdc1

Далее заходим на node-0 смотри файл inventory
на нем
cd /srv/kubespray
sudo  ansible-playbook -u 'ubuntu' -i inventory/sample/hosts.ini cluster.yml -b --key-file ~/.ssh/id_rsa
mkdir ~/.kube
sudo cp /etc/kubernetes/admin.conf ~/.kube/config

Там же(на node-0)
sudo helm repo add stable https://charts.helm.sh/stable --force-update
sudo helm repo update

cd /home/ubuntu
kubectl create -f data.yml

sudo helm install elasticsearch stable/elasticsearch --namespace logging--set data.persistence.storageClass=local-storage,master.persistence.storageClass=master-storage

sudo helm install fluentd stable/fluentd-elasticsearch --namespace logging --set elasticsearch.host=elasticsearch-client

sudo helm install kibana stable/kibana --namespace logging --set ingress.enabled=true,ingress.hosts[0]=kibana.mydomain.io --set env.ELASTICSEARCH_HOSTS=http://elasticsearch-client:9200

git clone https://github.com/prometheus-operator/kube-prometheus
cd kube-prometheus
kubectl create -f manifests/setup
kubectl create -f manifests/
until kubectl get customresourcedefinitions servicemonitors.monitoring.coreos.com ; do date; sleep 1; echo ""; done
until kubectl get servicemonitors --all-namespaces ; do date; sleep 1; echo ""; done
cd ..
kubectl create -f ingress-grafana-prometheus.yml

Для доступа к интерфейсе kibana и prometheus на своей локальной машине в файле /etc/hosts прописать
IP-первой-ноды kibana.mydomain.io
IP-второй-ноды kibana.mydomain.io
IP-третьей-ноды kibana.mydomain.io

IP-первой-ноды grafana.mydomain.io
IP-второй-ноды grafana.mydomain.io
IP-третьей-ноды grafana.mydomain.io
