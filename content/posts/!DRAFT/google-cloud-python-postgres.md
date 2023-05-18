                 
Create Project
=============

Создать приложение в гугл-консоли https://console.cloud.google.com/appengine/start

У проекта будут `Project name`, `Project number`, и `Project ID`

Проект - это "контейнер" для множества различных сервисов гугл.

Так же необходимо добавить кредитную карту в Billing. Деньги списыываться не будут, если использовать free tier.

Установить gcloud
======================

https://cloud.google.com/sdk/docs/install

Включить API для проекта
=======================

https://console.cloud.google.com/apis/enableflow?apiid=cloudbuild.googleapis.com&project=<project id>

Init
==================

Нужно запустить эту команду, она создаст нужные привязки (файлы в проекте никакие не создаются при этом)

    gcloud init


Google Storage предоставляется бесплатно только в регионах us-east1, us-west1, and us-central1. Возможно (!), что при использовании Storage лучше все сервисы разместить в одном регионе, потому
что для Multi-Region использования другие тарифы. Я не знаю, влияет ли это на Free Tier. Если Storage не предполагается использовать, то можно выбрать ближайший регион. Но иногда в некоторых 
регионах недоступны определенные сервисы (напр. Search API). 

Далее создаем "приложение". При этом нужно будет выбрать регион. Файлы в проекте не создаются.

    gcloud app create

Проверить информацию о приложении можно командой

    gcloud app describe

app.yaml
=====================

В корне приложения создать файл app.yaml с настройками проекта.

runtime: python311
env: standard
entrypoint: gunicorn -b :$PORT <PROJECTNAME>.wsgi:application

handlers:
- url: /.*
  script: auto

runtime_config:
  python_version: 3

Какие версии питона есть, можно посмотреть тут https://cloud.google.com/appengine/docs/standard/python3/runtime

.gcloudignore
==========================

Файл похож по своему смыслу на .gitignore, в нем можно исключить файлы, которые не должны аплоадится в GAE.
Имеет смысл добавить:

```
Pipfile
Pipfile.lock
.env
.env.neon
.idea
```

Dependencies
=========================

Зависимости должны быть в requirements.txt. Как написано в доках, Pipfile/Pipfile.lock не поддерживаются и этих файлов в проекте быть не должно.

App entry point
==========================

Стартовая точка прописывает в app.yaml

    entrypoint: gunicorn -b :$PORT main:app

Я так понял, можно не указывать entrypoint, тогда оно само поставит gunicorn и запустит с дефолтными настройками. Но тогда и gunicorn не надо указывать в requirement.txt
$PORT должен быть указан в переменной окружения. 

Assign code to App project
=====================================

    gcloud config set project <project-id>


Auth in google cloud
================================

    gcloud auth application-default login


Database Create
=========================

Navigate to the Cloud SQL dashboard and create a new Postgres instance with the following parameters. Может потребоваться нажать Enable API, чтобы включить Sql Api в проект.

Instance ID: mydb-instance
Password: Enter a custom password or generate it
Database version: PostgreSQL 14
Configuration: Development or Production (Development is close for me)
Region: The same region as your app
Zonal availability: Up to you


Special snippet for django's settings for ALLOWED_HOSTS
=================================================

# settings.py
from urllib.parse import urlparse
APPENGINE_URL = env('APPENGINE_URL', default=None)
if APPENGINE_URL:
    # ensure a scheme is present in the URL before it's processed.
    if not urlparse(APPENGINE_URL).scheme:
        APPENGINE_URL = f'https://{APPENGINE_URL}'

    ALLOWED_HOSTS = [urlparse(APPENGINE_URL).netloc]
    CSRF_TRUSTED_ORIGINS = [APPENGINE_URL]
    SECURE_SSL_REDIRECT = True
else:
    ALLOWED_HOSTS = ['*']


Secret Manager
====================================

Включаем его по ссылке https://console.cloud.google.com/security/secret-manager.

Создаем нужный secret как в .env файле командой `gcloud secrets create django-secrets --data-file .env.neon`

Добавляем зависимость в проект `pip install google-cloud-secret-manager`

Подробно см тут - [Python Decouple and Google App Secrets](https://www.codingforentrepreneurs.com/blog/google-secrets-python-decouple-github-actions/)

Суть в том, что добавляется файл `src/env.py`, который служит прокладкой между django и python-decouple. Он распознает среду
выполнения, и если среда локальная (имеется файл .env), то secrets читаются из него, а иначе они читаюются через 
google-secrets-manager. 

Static
=======================================

Перед деплоем собираем статику локально - она будет деплоится в GAE через директорию `collect_static`:

    python manage.py collectstatic --noinput

Затем добавляем в `app.yaml`

    handlers:
    - url: /.*
      script: auto
    - url: /static                   * new line
      static_dir: collect_static     * new line

И наконец устанавливаем whitenoise. Django обслуживает статику только в режиме DEBUG=True, а на продакшене нам 
нужно стороннее решение типа whitenoise.

Для настройки добавляем всего одну строчку в settings.py

    `'whitenoise.middleware.WhiteNoiseMiddleware',`

после `security.SecurityMiddleware`.

OTHER
---------------------------

Set API caps for prevent overhelm free limits:

https://cloud.google.com/apis/docs/capping-api-usage

Google Always Free Tier

https://cloud.google.com/free/docs/free-cloud-features#free-tier


USEFULL COMMANDS
---------------------------------

- Проверить информацию о приложении `gcloud app describe`
- Версии компонентов gcloud `gcloud version`
- Return <project-id> `gcloud config get-value project`
- Логи `gcloud app logs tail -s default`

USEFULL LINKS
------------------------------
- [Python Decouple and Google App Secrets](https://www.codingforentrepreneurs.com/blog/google-secrets-python-decouple-github-actions/)
- [Django and GAE](https://testdriven.io/blog/django-gae)
- [Official GAE Django Example](https://github.com/GoogleCloudPlatform/python-docs-samples/tree/main/appengine/standard_python3)

