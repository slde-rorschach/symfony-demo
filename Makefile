RESULT_DIR = ./qa-results
PHPLOC_CMD = ./vendor/bin/phploc


build: composer-install phploc


composer-install:
	composer install

qa-results:
	mkdir ./qa-results

phploc: qa-results
	$(PHPLOC_CMD) --count-tests --log-csv=$(RESULT_DIR)/phploc.csv --log-xml=$(RESULT_DIR)/phploc.xml src tests

