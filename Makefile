RESULT_DIR = ./qa-results
PHPLOC_CMD = ./vendor/bin/phploc
PHPCSFIXER_CMD = ./vendor/bin/php-cs-fixer
PDEPEND_CMD = ./vendor/bin/pdepend
SYMFONY_CONSOLE_CMD = ./bin/console

build: composer-install

qa-tools: lint-yaml lint-twig qa-results phploc pdepend

composer-install:
	composer install

qa-results:
	mkdir ./qa-results

phploc: qa-results
	$(PHPLOC_CMD) --count-tests --log-csv=$(RESULT_DIR)/phploc.csv --log-xml=$(RESULT_DIR)/phploc.xml src tests

php-cs-fixer: qa-results
	$(PHPCSFIXER_CMD) fix src --dry-run --level="symfony" --diff  > $(RESULT_DIR)/php-cs-fixer.txt

pdepend: qa-results
	$(PDEPEND_CMD) --dependency-xml=$(RESULT_DIR)/pdepend-dependency.xml --jdepend-chart=$(RESULT_DIR)/pdepend-jdepend-chart.svg --jdepend-xml=$(RESULT_DIR)/pdepend-jdepend.xml --overview-pyramid=$(RESULT_DIR)/pdepend-overview-pyramid.svg --summary-xml=$(RESULT_DIR)/pdepend-summary.xml src

lint-yaml:
	$(SYMFONY_CONSOLE_CMD) lint:yaml app/config
	$(SYMFONY_CONSOLE_CMD) lint:yaml src

lint-twig:
	$(SYMFONY_CONSOLE_CMD) lint:twig app/Resources/views
