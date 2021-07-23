#FROM alexdo/python-2.4-alpine
FROM ubuntu:18.04
RUN apt update -qq\
  && apt install -y python \
  && apt install -y python-pip \
  && apt install -y python3.6 \
  && apt install -y python3-pip \
  && apt install -y build-essential \
  && apt install -y git

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

# RUN git clone https://github.com/express42/search_engine_crawler.git
# WORKDIR $APP_HOME/search_engine_crawler
# RUN pip3 install -r requirements.txt -r requirements-test.txt
# RUN echo "Тестирование кода...search_engine_crawler"
# RUN python3 -m unittest discover -s tests/
# RUN coverage run -m unittest discover -s tests/ 
# RUN coverage report --include crawler/crawler.py

# WORKDIR $APP_HOME
# RUN git clone https://github.com/express42/search_engine_ui.git
# WORKDIR $APP_HOME/search_engine_ui
# RUN pip install -r requirements.txt -r requirements-test.txt
# RUN echo "Тестирование кода...search_engine_ui"
# RUN python -m unittest discover -s tests/
# RUN coverage run -m unittest discover -s tests/
# RUN coverage report --include ui/ui.py
