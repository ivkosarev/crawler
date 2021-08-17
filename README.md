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

Сборка и тестирование кода приложения происходит с использованием Alpine Linux, что позволяет существенно снизить размеры DockerImage. Dockerfile для сборки образов лежат в папке docker/dockerfile. Приложение состоит из двух компонеттов search_engine_crawler https://github.com/express42/search_engine_crawler.git (docker/dockerfile/crawler/Dockerfile) и search_engine_ui  https://github.com/express42/search_engine_ui.git (docker/dockerfile/ui/Dockerfile).
  Файл docker/dockerfile/testing/Dockerfile используется для сборки образа для тестирования приложения, файл docker/dockerfile/yc_ci_kubectl_helm/Dockerfile - для развертывания приложения в кластере и представляет собой докерфайл образа alpine linux с предустановленным helm и kubectl.
Сборка образов приложения и проверка докерфайлов происходит в автоматическом режиме с использованием технологии CI/CD Gitlab.

 Pipiline сборки образов приложения:
 - Build_images_docker

 Собраные образы mzabolotnov/crawler:k8s_ci_a3.0 и mzabolotnov/crawler:k8s_ci_a3.0 пушатся на DockerHub. В дальнейшем они будут использованы при деплое приложения

 ## Тесты приложения

 Для тестов кода приложения создан Pipeline
  - test_crawler
  
 Результаты тестов преставляют собой артефакт, который можно скачать.
 Данный пайплайн не активен для ветки main

 ## Проверка кода Terraform

 Pipeline проверки кода терраформ
 - k8s_terraform_plan_dev
 - k8s_terraform_plan_prod
 Данные пайплайны не актифны, если изменения не затрагивают папки k8s_crawler/terraform_k8s и k8s/terraform соответственно

 ## Деплой и удаление приложения в/из кластера

Pipeline деплоя и удаления приложения в окружение DEV
- deploy_k8s_dev_helm
- destroy_k8s_dev_helm
активен на всех ветках кроме main

Pipeline деплоя и удаления приложения в окружение PROD
- deploy_k8s_prod_helm
- destroy_k8s_prod_helm
активен на ветке main


#### Разворачивание приложения происходит в двух окружениях dev и prod (два кластера kubernetes)
## Подключение GitLab к кластерам Kubernetes (общий подход)
В настройка GitLab CI/CD задано две переменные
$KUBE_URL и $KUBE_TOKEN

- `KUBE_URL=$(kubectl cluster-info | grep -E 'Kubernetes master|Kubernetes control plane' | awk '/http/ {print $NF}')`

Далее создаем сервис-аккаунт gitlab в кластере

- `kubectl apply -f k8s_crawler/gitlab/gitlab-admin-service-account.yaml`

Определяем токен доступа

- `KUBE_TOKEN=$(kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep gitlab | awk '{print $1}') | grep token: | awk '{print $2}')`

Далее подключаемся

- `kubectl config set-cluster k8s --server="$KUBE_URL" --insecure-skip-tls-verify=true`
- `kubectl config set-credentials admin --token="$KUBE_TOKEN"`
- `kubectl config set-context default --cluster=k8s --user=admin`
- `kubectl config use-context default`
## Разворачиваем окружение dev в кластере Kubernetes платформы YandexCloud
Кластер для окружения dev создан при помощи terraform. 
- `cd k8s_crawler/terraform_k8s && terraform apply`
Устанавливаем nginx ingress
- `kubectl create ns ingress`
- `helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx`
- `helm repo update`
- `helm install ingress-nginx ingress-nginx/ingress-nginx -n ingress`
Разворачиваем с использования хельм чарта bitnami/Prometheus
- `kubectl create ns monitoring`
- `helm repo add bitnami https://charts.bitnami.com/bitnami && helm repo update && helm install prom-app bitnami/kube-prometheus -f k8s_crawler/monitoring/prometheus/values.yaml -n monitoring`
Разворачиваем с использования хельм чарта bitnami/Grafana
- `helm install grafana-app bitnami/grafana -f k8s_crawler/monitoring/grafana/values.yaml -n monitoring`
Dashboard для мониторинга кластера
- k8s_crawler/monitoring/grafana/kubernetes-cluster-monitoring-via-prometheus_rev3.json
- k8s_crawler/monitoring/grafana/deployment-metrics_rev1.json
  взято отсюда https://grafana.com/grafana/dashboards/315

Dashboard для мониторинга приложения
- k8s_crawler/monitoring/grafana/Crawler dashboard_rev1.json

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

деплой приложения в кластер производится и хелм чарта k8s_crawler/crawler/chart/app.
helm upgrade app k8s_crawler/crawler/chart/app --install

#### DEV

Деплой приложения происходит в автоматическом режиме с использованием технологии CI/CD GitLab

Pipeline деплоя в dev
- deploy_k8s_dev_helm
Pipeline удаления приложения из dev
- destroy_k8s_dev_helm

URL: http://mikhza.twilightparadox.com/
Prometheus URL: http://prometheus.crawler
Grafana URL: http://grafana.crawler
Alertmanager: http://alertmanager.crawler

#### PROD

Деплой приложения происходит в автоматическом режиме с использованием технологии CI/CD GitLab

Pipeline деплоя в prod
- deploy_k8s_prod_helm
Pipeline удаления приложения из prod
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
