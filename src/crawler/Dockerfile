FROM python:3.6.0

ENV MONGO  crawler_db 
ENV MONGO_PORT 27017
ENV RMQ_HOST rabbitmq
ENV RMQ_QUEUE queue
ENV RMQ_USERNAME guest
ENV RMQ_PASSWORD guest
ENV CHECK_INTERVAL 5
ENV EXCLUDE_URLS='.*github.com'

WORKDIR /crawler
COPY crawler/. /crawler

RUN apt update -qq && apt install -y build-essential

RUN pip install -r /crawler/requirements.txt 

ENTRYPOINT ["python", "-u","crawler/crawler.py","https://vitkhab.github.io/search_engine_test_site/"]
