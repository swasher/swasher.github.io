---
Title: Docker-django-postgres
Date: 2022-07-14 10:06
Category: [IT]
Tags: [docker, django, postgres]
Author: Swasher
---

Создаем файл `docker-compose.yml`

version: "3.9"

volumes:
    postgres_data:
services:
  db:
    image: postgres
    volumes:
      - postgres_data:/var/lib/postgresql/data
    environment:
      - POSTGRES_DB=${DATABASE_NAME}
      - POSTGRES_USER=${DATABASE_USER}
      - POSTGRES_PASSWORD=${DATABASE_PASSWORD}
    ports:
      - 5432:5432


.env file must contain secrets:
DATABASE_NAME=postgres     # for docker, you can leave this
DATABASE_USER=postgres     # for docker, you can leave this
DATABASE_PASSWORD=postgres # for docker, you can leave this
DATABASE_HOST=localhost    # for docker, you can leave this


settings.py пишем параметры коннекта, в том числе для хероку
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': config('DATABASE_NAME', ''),
        'USER': config('DATABASE_USER', ''),
        'PASSWORD': config('DATABASE_PASSWORD', ''),
        'HOST': config('DATABASE_HOST', ''),
        'PORT': '5432',
    }
}
# configure database for heroku
db_from_env = dj_database_url.config(conn_max_age=500)
DATABASES['default'].update(db_from_env)


Ensure if docker is running.


Then you can use a commands:

Build docker:
	docker compose up -d  --build

Start and stop
	docker compose up -d
	docker compose down

ssh connect:
	docker exec -it <container name> bash

For filly recreate db:
	docker compose down
	docker volume prune --force
	docker compose up -d
	sleep 3
	python manage.py makemigrations timer
	python manage.py migrate --run-syncdb
	python manage.py loaddata manager
	python manage.py createsuperuser --username=swasher --email=mr.swasher@gmail.com;

