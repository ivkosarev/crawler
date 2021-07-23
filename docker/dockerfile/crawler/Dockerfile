#FROM alexdo/python-2.4-alpine
FROM python:3.6-alpine
# FROM ubuntu:18.04

# RUN apt update -qq\
#   && apt install -y python3.6 \
#   && apt install -y python3-pip \
#   && apt install -y build-essential \
#   && apt install -y git
RUN apk add git=2.32.0-r0

ENV MONGO crawler_db 
ENV MONGO_PORT 27017
ENV RMQ_HOST rabbitmq
ENV RMQ_QUEUE queue
ENV RMQ_USERNAME guest
ENV RMQ_PASSWORD guest
ENV CHECK_INTERVAL 5
ENV EXCLUDE_URLS='.*github.com'


ENV APP_HOME /app
RUN git clone https://github.com/express42/search_engine_crawler.git $APP_HOME
# RUN mkdir $APP_HOME

# WORKDIR $APP_HOME
# RUN git clone https://github.com/express42/search_engine_crawler.git
# ADD ./tests $APP_HOME/test
# ADD ./crawler $APP_HOME/crawler
# ADD requirements.txt $APP_HOME/crawler

# WORKDIR $APP_HOME/crawler
WORKDIR $APP_HOME

# RUN apt update -qq && apt install -y build-essential

RUN pip install -r requirements.txt 

#CMD bash
#ENTRYPOINT ["python3", "-u","crawler.py","https://vitkhab.github.io/search_engine_test_site/"]
#CMD sleep 30 && python3 -u crawler.py https://vitkhab.github.io/search_engine_test_site/
CMD python -u ./crawler/crawler.py https://vitkhab.github.io/search_engine_test_site/
