#
# See ./CONTRIBUTING.rst
#

OS := $(shell uname)
.PHONY: help build up requirements clean lint test help
.DEFAULT_GOAL := help

PROJECT := godot-pong

PYTHON_VERSION=3.6.4
PYENV_NAME="${PROJECT}"

# Configuration.
SHELL := /bin/bash
ROOT_DIR=$(shell pwd)
MESSAGE:=༼ つ ◕_◕ ༽つ
MESSAGE_HAPPY:="${MESSAGE} Happy Coding"
SOURCE_DIR=$(ROOT_DIR)/
REQUIREMENTS_DIR=$(ROOT_DIR)/requirements
FILE_README:=$(ROOT_DIR)/README.rst
KEYS_DIR:="${HOME}/.ssh"
PATH_DOCKER_COMPOSE:=provision/docker-compose

pip_install := pip install -r

help:
	@echo '${MESSAGE} Makefile for ${PROJECT}'
	@echo ''
	@echo 'Usage:'
	@echo '    stage                     create stage with pyenv'
	@echo '    clean                     remove files of build'
	@echo '    setup                     install requirements'
	@echo ''

clean:
	@echo "$(TAG)"Cleaning up"$(END)"
ifneq (Darwin,$(OS))
	@sudo rm -rf .tox *.egg *.egg-info dist build .coverage
	@sudo rm -rf docs/build
	@sudo find . -name '__pycache__' -delete -print -o -name '*.pyc' -delete -print -o -name '*.pyo' -delete -print -o -name '*~' -delete -print -o -name '*.tmp' -delete -print
else
	@rm -rf .tox *.egg *.egg-info dist build .coverage
	@rm -rf docs/build
	@find . -name '__pycache__' -delete -print -o -name '*.pyc' -delete -print -o -name '*.pyo' -delete -print -o -name '*~' -delete -print -o -name '*.tmp' -delete -print
endif
	@echo

setup: clean
	$(pip_install) requirements.txt
	@if [ -e "${REQUIREMENTS_DIR}/private.txt" ]; then \
			$(pip_install) "${REQUIREMENTS_DIR}/private.txt"; \
	fi
	pre-commit install
	cp -rf .hooks/prepare-commit-msg .git/hooks/

stage: clean
	@if [ -e "$(HOME)/.pyenv" ]; then \
		eval "$(pyenv init -)"; \
		eval "$(pyenv virtualenv-init -)"; \
	fi
	pyenv virtualenv "${PYTHON_VERSION}" "${PYENV_NAME}" >> /dev/null 2>&1 || echo $(MESSAGE_HAPPY)
	pyenv activate "${PYENV_NAME}" >> /dev/null 2>&1 || echo $(MESSAGE_HAPPY)
