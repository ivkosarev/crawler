FROM ubuntu:18.04
RUN apt update \
 && apt install -y python-pip


ENV APP_HOME /app
RUN mkdir $APP_HOME

WORKDIR $APP_HOME
ADD ./tests $APP_HOME/test
ADD ./ui $APP_HOME/ui
ADD requirements.txt $APP_HOME

RUN pip install -r requirements.txt


ENV MONGO mongo_db
ENV MONGO_PORT 27017


WORKDIR $APP_HOME/ui

#CMD ["bash"]
ENTRYPOINT FLASK_APP=ui.py gunicorn ui:app -b 0.0.0.0
