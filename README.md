1.0 Заболотнов М.Ю.
Приложение UI запускается из файла src/docker-compose.yml (cd ./src || docker-compose up -d). Состоит из двух docker-контейнеров mzabolotnov/ui_crawler:1.0 и mongo3.2:latest. Контейнер mzabolotnov/ui_crawler:1.0 собирается из src/ui_crawler/Dockerfile. Создается две docker-bridge-сети - front_net и back_net. Контейнер ui_crawler запущен в сетях front_net и back_net, rконтейнер mongo3.2 - в front_net. ui_crawler открывает 8000 поорт на внешнем адресе. Подключение через браузер http://<внеш_IP>:8000

