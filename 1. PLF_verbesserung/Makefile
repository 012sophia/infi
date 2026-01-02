SQL_FILES := $(sort $(wildcard *.sql))

.PHONY: clean empty-sql

clean: empty-sql

empty-sql:
	@if [ -z "$(SQL_FILES)" ]; then \
		echo "No .sql files found in $$(pwd)"; \
	else \
		for f in $(SQL_FILES); do \
			: > "$$f"; \
		done; \
		echo "Emptied: $(SQL_FILES)"; \
	fi