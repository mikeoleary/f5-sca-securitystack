.PHONY: install test wheel

default: test

install:
	pipenv install --dev --skip-lock

zip:
	pipenv lock -r > requirements.txt
	pipenv run pip install -r requirements.txt --no-deps -t ./
	zip -FSr ha_iapp.zip ./*
	pipenv run pip uninstall -r requirements.txt -y
	rm -rf requirements.txt f5_sca_libs*