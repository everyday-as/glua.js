PROCESSOR ?= "/opt/v8/tools/linux-tick-processor"
LIB := ./node_modules
BIN := $(LIB)/.bin

# Install and internal updates
# ----------------------------

install:
	npm install

# This is required if mocha, expect or benchmark is updated.
update:
	cp -v $(LIB)/spec/lib/* test/lib/
	cp -v $(LIB)/benchmark/benchmark.js test/lib/


.PHONY: install update

# Tests
# -----

test:
	node test/runner.js --console

# Scaffold all test files in the scaffolding dir.
scaffold-tests:
	$(foreach file,\
		$(notdir $(wildcard test/scaffolding/*)),\
		$(MAKE) scaffold-test FILE=$(file);\
	)

scaffold-test:
	./scripts/scaffold-test --name=$(FILE) \
		test/scaffolding/$(FILE) \
		> test/spec/$(FILE).js

.PHONY: test scaffold-tests scaffold-test

# Benchmark
# ---------

benchmark:
	./scripts/benchmark -v benchmarks/lib/ParseLua.lua

profile:
	bash benchmarks/run.sh -v --processor $(PROCESSOR) --profile HEAD

benchmark-previous:
	bash benchmarks/run.sh --js HEAD HEAD~1

.PHONY: benchmark profile benchmark-previous