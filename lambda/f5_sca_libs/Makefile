.PHONY: install test wheel

default: test

install:
	pipenv install --dev --skip-lock

test:
	PYTHONPATH=./src pytest

wheel:
	pipenv run python setup.py bdist_wheel