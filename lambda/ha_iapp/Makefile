.PHONY: install test wheel

default: zip

install:
	pipenv install --dev --skip-lock

zip:
	pipenv lock -r > requirements.txt
	pipenv run pip install -r requirements.txt -t ./
	chmod 644 $$(find ./ -type f)
	chmod 755 $$(find ./ -type d)
	zip -FSr ha_iapp.zip ./*
	pipenv run pip uninstall -r requirements.txt -y
	rm -rf requirements.txt f5_sca_libs* bin ch* dev* certifi* f5* ic* id* re* setup* six* url* boto* cfn* date* doc* jme* python_dateutil*