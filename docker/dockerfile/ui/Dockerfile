FROM python:3.6-alpine

RUN apk add git=2.32.0-r0

ENV MONGO crawler_db
ENV MONGO_PORT 27017


ENV APP_HOME /app
RUN git clone https://github.com/express42/search_engine_ui.git $APP_HOME
WORKDIR $APP_HOME
RUN pip install -r requirements.txt





WORKDIR $APP_HOME/ui
#CMD ["bash"]
ENTRYPOINT FLASK_APP=ui.py gunicorn ui:app -b 0.0.0.0
