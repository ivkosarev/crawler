#FROM alexdo/python-2.4-alpine
FROM ubuntu:18.04
RUN apt update \
  && apt install -y python3.6 \
  && apt install -y python3-pip

ENV MONGO  crawler_db 
ENV MONGO_PORT 27017
ENV RMQ_HOST rabbitmq
ENV RMQ_QUEUE queue
ENV RMQ_USERNAME guest
ENV RMQ_PASSWORD guest
ENV CHECK_INTERVAL 5
ENV EXCLUDE_URLS='.*github.com'


ENV APP_HOME /app
RUN mkdir $APP_HOME

WORKDIR $APP_HOME
ADD ./tests $APP_HOME/test
ADD ./crawler $APP_HOME/crawler
ADD requirements.txt $APP_HOME/crawler

WORKDIR $APP_HOME/crawler


RUN apt update -qq && apt install -y build-essential

RUN pip3 install -r requirements.txt 

#CMD bash
ENTRYPOINT ["python3", "-u","crawler.py","https://vitkhab.github.io/search_engine_test_site/"]
