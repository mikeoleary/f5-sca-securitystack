.PHONY: install cft

default: cft

install:
	cd ha_iapp
	pipenv install --dev --skip-lock

cft:
	pipenv run python ./ha_iapp/gen_cft.py