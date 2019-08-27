.PHONY: install cft

default: cft

install:
	pipenv install --skip-lock

cft:
	pipenv run python gen_ha_iapp_cft.py
	pipenv run python gen_install_lambda_cft.py