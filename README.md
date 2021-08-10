# О чем проект

Данный проект это наша интерпретация развертывания приложения Crawler

## Описание

Приложение Crawler парсит сайты и складывает все ссылки в базу данных.
Данный проект разворачивает данное приложение.
Используется методология CI/CD
Следующие идеи были реализованы
- Версионирование приложения
- Тестирование кода приложения
- Разворачивание приложение в кластере Kubernetes
- Мониторинг приложение и кластера 

## Поехали...

## Сборка образов приложения

Сборка и тестирование кода приложения происходит с использованием Alpine Linux, что позволяет существенно снизить размеры DockerImage. Dockerfile для сборки образов лежат в папке docker/dockerfile. Приложение состоит из двух компонеттов search_engine_crawler (docker/dockerfile/crawler/Dockerfile) и search_engine_ui (docker/dockerfile/ui/Dockerfile).
  Файл docker/dockerfile/testing/Dockerfile используется для сборки образа для тестирования приложения, файл docker/dockerfile/yc_ci_kubectl_helm/Dockerfile - для развертывания приложения в кластере и представляет собой докерфайл образа alpine linux с предустановленным helm и kubectl.
Сборка образов приложения и проверка докерфайлов происходит в автоматическом режиме с использованием технологии CI/CD Gitlab.
 
 Pipiline проверки корректности докерфайлов:
 - Validate-dockerfile

 Pipiline сборки образов приложения:
 - Build_images_docker

 Собраные образы mzabolotnov/crawler:k8s_ci_a3.0 и mzabolotnov/crawler:k8s_ci_a3.0 пушатся на DockerHub. В дальнейшем они будут использованы при деплое приложения

 ## Тесты приложения

 Для тестов кода приложения создан Pipeline
  - test_crawler
  
 Результаты тестов преставляют собой артефакт, который можно скачать.

 ## Проверка кода Terraform

 Pipeline проверки кода терраформ
 - terraform_plan 

#### Разворачивание приложения происходит в двух окружениях dev и prod

## Разворачиваем окружение dev в кластере Kubernetes платформы YandexCloud
Кластер для окружения dev собран вручную из двух нод. Устанавливаем nginx ingress
- `helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx`
- `helm repo update`
- `helm install ingress-nginx ingress-nginx/ingress-nginx`
Разворачиваем с использования хельм чарта bitnami/Prometheus
- `helm repo add bitnami https://charts.bitnami.com/bitnami && helm repo update && helm install prom-app bitnami/kube-prometheus -f k8s_crawler/monitoring/values.yaml`

## Разворачивание prod окружения на базе Kubernetes

Окружение разворачивается в yandex cloud по средствам проекта kubespray
* Для запуска необходимо иметь файлы ключей ssh ~/.ssh/id_rsa ~/.ssh/id_rsa.pub На файлах не должно стоять паролей
* из папки k8s/terraform `terraform init terraform apply`
* из папаки `ansible ansible-playbook node.yml`
- На каждой ноде из файла inventory выполнить: 
- `sudo mkdir -p /mnt/disks/vdc1`
- `sudo echo 'type=83' | sudo sfdisk /dev/vdb sudo echo 'type=83' | sudo sfdisk /dev/vdc`
- `sudo mkfs.ext4 /dev/vdb1 sudo mkfs.ext4 /dev/vdc1`
- `sudo mount /dev/vdb1 /mnt/disks/vdb1 sudo mount /dev/vdc1 /mnt/disks/vdc1`
* Далее заходим на node-0 смотри файл inventory на нем выполняем команды по разворачиванию кластера и настройке окружения
* `cd /srv/kubespray`
* `sudo ansible-playbook -u 'ubuntu' -i inventory/sample/hosts.ini cluster.yml -b --key-file ~/.ssh/id_rsa`
* `mkdir ~/.kube`
* `sudo cp /etc/kubernetes/admin.conf ~/.kube/config`
- Там же(на node-0) устанавливаем elacticsearch, fluend, kibana (EFK)
- `sudo helm repo add stable https://charts.helm.sh/stable --force-update`
- `sudo helm repo update`
- `cd /home/ubuntu`
- `kubectl create -f data.yml`
- `sudo helm install elasticsearch stable/elasticsearch --namespace logging --set data.persistence.storageClass=local-storage,master.persistence.storageClass=master-storage`
- `sudo helm install fluentd stable/fluentd-elasticsearch --namespace logging --set elasticsearch.host=elasticsearch-client`
- `sudo helm install kibana stable/kibana --namespace logging --set ingress.enabled=true,ingress.hosts[0]=kibana.mydomain.io --set env.ELASTICSEARCH_HOSTS=http://elasticsearch-client:9200`
* Далее устанавливаем систему мониторинга. Prometheus, Graphana
* `git clone https://github.com/prometheus-operator/kube-prometheus`
* `cd kube-prometheus`
* `kubectl create -f manifests/setup`
* `kubectl create -f manifests/`
* `until kubectl get customresourcedefinitions servicemonitors.monitoring.coreos.com ; do date; sleep 1; echo ""; done`
* `until kubectl get servicemonitors --all-namespaces ; do date; sleep 1; echo ""; done cd .. kubectl create -f ingress-grafana-prometheus.yml`
- Для доступа к интерфейсе kibana и prometheus на своей локальной машине в файле /etc/hosts прописать
- IP-первой-ноды kibana.mydomain.io
- IP-второй-ноды kibana.mydomain.io
- IP-третьей-ноды kibana.mydomain.io

- IP-первой-ноды grafana.mydomain.io
- IP-второй-ноды grafana.mydomain.io
- IP-третьей-ноды grafana.mydomain.io

## Деплой приложение crawler в двух окружениях dev и prod

#### DEV

Деплой приложения происходит в автоматическом режиме с использованием технологии CI/CD GitLab

Pipeline деплоя в dev
- deploy_k8s_dev_helm
Pipeline удаления приложения из dev
- destroy_k8s_dev_helm

URL: http://mikhza-prod.twilightparadox.com/
Prometheus URL: http://prometheus.crawler

#### PROD

Деплой приложения происходит в автоматическом режиме с использованием технологии CI/CD GitLab

Pipeline деплоя в dev
- deploy_k8s_prod_helm
Pipeline удаления приложения из dev
- destroy_k8s_prod_helm

URL: http://mikhza-prod.twilightparadox.com/
Prometheus URL: http://prometheus.mydomain.io
Grafana URL: http://grafana.mydomain.io
Kibana URL: http://kibana.mydomain.io


## Авторы

Имена и контактная информация авторов
* **Шибанов Алексей** _ag.shibanov@gmail.com_
* **Заболотнов Михаил** _m.zabolotnov@gmail.com_
* **Иван Косарев** _ivkosarev@gmail.com_
