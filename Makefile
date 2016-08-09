RESULT_DIR = ./qa-results
PHPLOC_CMD = ./vendor/bin/phploc
PHPCSFIXER_CMD = ./vendor/bin/php-cs-fixer
PDEPEND_CMD = ./vendor/bin/pdepend
SYMFONY_CONSOLE_CMD = ./bin/console
PHPCPD_CMD = ./vendor/bin/phpcpd
PHPMD_CMD = ./vendor/bin/phpmd
PHPMETRICS_CMD = ./vendor/bin/phpmetrics
PHPUNIT_CMD = ./vendor/bin/phpunit
build: composer-install

qa-tools: lint-yaml lint-twig phploc php-cs-fixer phpunit pdepend phpcpd phpmd phpmetrics

composer-install:
	composer install

qa-results:
	mkdir ./qa-results

phploc: qa-results
	$(PHPLOC_CMD) --count-tests --log-csv=$(RESULT_DIR)/phploc.csv --log-xml=$(RESULT_DIR)/phploc.xml src tests

php-cs-fixer: qa-results
	-$(PHPCSFIXER_CMD) fix src --dry-run --level="symfony" --diff  > $(RESULT_DIR)/php-cs-fixer.txt

pdepend: qa-results
	$(PDEPEND_CMD) --dependency-xml=$(RESULT_DIR)/pdepend-dependency.xml --jdepend-chart=$(RESULT_DIR)/pdepend-jdepend-chart.svg --jdepend-xml=$(RESULT_DIR)/pdepend-jdepend.xml --overview-pyramid=$(RESULT_DIR)/pdepend-overview-pyramid.svg --summary-xml=$(RESULT_DIR)/pdepend-summary.xml src

lint-yaml: qa-results
	$(SYMFONY_CONSOLE_CMD) lint:yaml app/config
	$(SYMFONY_CONSOLE_CMD) lint:yaml src

lint-twig: qa-results
	$(SYMFONY_CONSOLE_CMD) lint:twig app/Resources/views

phpcpd: qa-results
	$(PHPCPD_CMD) src/

phpmd: qa-results
	-$(PHPMD_CMD) src/ xml cleancode,codesize,controversial,design,naming,unusedcode --reportfile $(RESULT_DIR)/phpmd.xml

phpmetrics: qa-results
	$(PHPMETRICS_CMD) --report-html=$(RESULT_DIR)/phpmetrics.html src/


phpunit: qa-results
	$(PHPUNIT_CMD) --coverage-html=$(RESULT_DIR)/phpunit-coverage --log-junit=$(RESULT_DIR)/phpunit-junit.xml --coverage-clover=$(RESULT_DIR)/phpunit-clover.xml --coverage-crap4j=$(RESULT_DIR)/phpunit-crap4j.xml src/

.PHONY: build qa-tools composer-install phploc php-cs-fixer pdepend lint-yaml lint-twig phpcpd phpmd phpmetrics phpunit
