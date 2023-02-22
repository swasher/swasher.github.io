---
title: "Pyenv and poetry together"
date: 2023-02-22T11:54:41+02:00
draft: false
Tags: [pyenv, poetry]
Categories: [IT]
---

Решение найдено тут [link](https://medium.com/macoclock/django-setup-in-2022-with-pyenv-poetry-on-macos-b0969830bec8)

Под windows используем пакет [pyenv for Windows](https://github.com/pyenv-win/pyenv-win).

Устанавливаем `pyenv` и `poetry` как написано в документации.

С помощью `pyenv` устанавливаем нужные нам версии питон. При этом `py launcher` *должен* быть удален (или отключен),
а сам питон может быть установлен в системе любым способом, `pyenv` его найдет и определит. Но имхо удобнее 
все версии питона централизовано устанавливать через `pyenv`.

Ищем достапные в репозитории версии 

```shell
$ pyenv install -l | findstr 3.1
```

Устанавливаем нужные нам версии в систему

```shell
$ pyenv install 3.10.2 
$ pyenv install 3.5.2
```
В папке проекта устанавливаем версию по-умолчанию

```shell
$ pyenv local 3.5.2
```
Появится файл `.python-version` c содержимым `3.5.2`

Теперь выполнив команду python в этой папке, у нас автоматически будет использоваться версия 3.5.2:

```shell
$ python --version
Python 3.10.2
```

Чтобы установить версую по-умолчанию для всех остальных папок, используем global: `pyenv global <version>`



```shell
C:\Users\OLEKSII\testproject>poetry init
INFO: Could not find files for the given pattern(s).
This command will guide you through creating your pyproject.toml config.
Package name [testproject]:
Version [0.1.0]:
Description []:                                                                         
Author [None, n to skip]:  n                                                            
License []:                                                                             
Compatible Python versions [^3.11]:  3.5.2  <<<<==== INSERT OUR ACTUAL VERSION
                                                                                                                                      
Would you like to define your main dependencies interactively? (yes/no) [yes] no
Would you like to define your development dependencies interactively? (yes/no) [yes] no 
Generated file                                                                                                                                                                  
[tool.poetry]
name = "testproject"
version = "0.1.0"
description = ""                                                                        
authors = ["Your Name <you@example.com>"]                                               
readme = "README.md"                                                                                                                                                          

[tool.poetry.dependencies]                                                              
python = "3.5.2"                                                                                                                                                                



[build-system]
requires = ["poetry-core"]
build-backend = "poetry.core.masonry.api"

Do you confirm generation? (yes/no) [yes]
                                               
```

Теперь обновите env у poetry, указав pyenv — это очень важный шаг. Когда вы установили poetry, она установила python 3.10.5 в качестве системного python, поэтому вам нужно переопределить это, указав правильную env для poetry с помощью `poetry env use $(pyenv which python)`. Вам нужно сделать это только один раз.

```shell
λ poetry env info

Virtualenv
Python:         3.11.2
Implementation: CPython
Path:           NA
Executable:     NA

System
Platform:   win32
OS:         nt
Python:     3.11.2
Path:       C:\Users\OLEKSII\.pyenv\pyenv-win\versions\3.11.2
Executable: C:\Users\OLEKSII\.pyenv\pyenv-win\versions\3.11.2\python.exe
                                                     ^^^^^^^^^^ poetry use system python!


λ poetry env use $(pyenv which python)
Creating virtualenv testproject-s9DjT1w_-py3.5 in C:\Users\OLEKSII\AppData\Local\pypoetry\Cache\virtualenvs
Using virtualenv: C:\Users\OLEKSII\AppData\Local\pypoetry\Cache\virtualenvs\testproject-s9DjT1w_-py3.5


λ poetry env info

Virtualenv
Python:         3.5.2
Implementation: CPython
Path:           C:\Users\OLEKSII\AppData\Local\pypoetry\Cache\virtualenvs\testproject-s9DjT1w_-py3.5
Executable:     C:\Users\OLEKSII\AppData\Local\pypoetry\Cache\virtualenvs\testproject-s9DjT1w_-py3.5\Scripts\python.exe
Valid:          True

System
Platform:   win32
OS:         nt
Python:     3.5.2
Path:       C:\Users\OLEKSII\.pyenv\pyenv-win\versions\3.5.2
Executable: C:\Users\OLEKSII\.pyenv\pyenv-win\versions\3.5.2\python.exe
                                                      ^^^^^^^^^^ now python exec from virtual env!!! 

```
Теперь мы можем создать виртуальное окружение при помощи

```shell
poetry instrall  <= this command use existing pyproject.toml
OR
poetry install <package-name>
```

