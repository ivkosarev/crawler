***
Crawler
***
 Здесь представлено как поднять в Яндекс клауде виртуальный хост с поднятыми контейнерами:
 1.mongo_db
 2.rabbitmq
 3.crawler
 4.ui
 5.prometheus
 6.node-exporter
 7.cadvisor
***
git clone
cd terraform  
terraform apply
***
Перед запуском надо в папке терраформа заполнить файл terraform.tfvars(пример в terraform.tfvars.example, вся инфа берется из вашего яндекс.клауда)


В конце терраформ выплюнет в stdout айпишник тачки, либо его можно найти в своем compute cloud.
На порту 8000 торчит веб-морда кравлера, оно даже чето там ищет.
***
