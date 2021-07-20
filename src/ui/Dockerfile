FROM ubuntu:18.04
RUN apt update -qq\
 && apt install -y python-pip \
 && apt install -y git


ENV APP_HOME /app
RUN git clone https://github.com/express42/search_engine_ui.git $APP_HOME
# RUN mkdir $APP_HOME

WORKDIR $APP_HOME
# ADD ./tests $APP_HOME/test
# ADD ./ui $APP_HOME/ui
# ADD requirements.txt $APP_HOME/ui

# WORKDIR $APP_HOME/ui
RUN pip install -r requirements.txt

ENV MONGO crawler_db
ENV MONGO_PORT 27017



WORKDIR $APP_HOME/ui
#CMD ["bash"]
ENTRYPOINT FLASK_APP=ui.py gunicorn ui:app -b 0.0.0.0
