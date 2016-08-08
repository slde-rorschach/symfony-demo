RESULT_DIR = ./qa-results
PHPLOC_CMD = ./vendor/bin/phploc
PHPCSFIXER_CMD = ./vendor/bin/php-cs-fixer

build: composer-install phploc


composer-install:
	composer install

qa-results:
	mkdir ./qa-results

phploc: qa-results
	$(PHPLOC_CMD) --count-tests --log-csv=$(RESULT_DIR)/phploc.csv --log-xml=$(RESULT_DIR)/phploc.xml src tests

php-cs-fixer: qa-results
	$(PHPCSFIXER_CMD) fix src --dry-run --level="symfony" --diff  > $(RESULT_DIR)/php-cs-fixer.txt