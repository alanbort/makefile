# Macros
HELP_MAKE_TARGETS = @cat Makefile | \
                    grep -E -e '[a-z\-]*:\s*[a-z]*\-?[a-z]* \#.*$$' | \
                    grep -v '^ *\#' | \
                    grep --color '^[a-z\-]*' 
NOTIMPLEMENTED = @echo "ERROR: Make Target Not implemented" && exit 1

VENV = if [ -d venv/py3 ]; then . venv/py3/bin/activate; fi; 

.PHONY: help clean cleanall build test release rc releasecandidate git-reset

default: docker-setup

#### Documentation and help

help:             # show quick list of actions
	@echo "Make Target       Action"
	@echo "==============    ======================================="
	$(HELP_MAKE_TARGETS)

# General Makefile Targets
# These should be the public interface and invoke Make with repository specific targets
config:           # Configures the default make behavior. Hint: Use make venv configure as a last resort if plain make configure doesn't work.
configure:        # Alias for config
	@$(VENV) python3 ./configure.py

clean:            # Cleans generated artifacts
	$(MAKE) clean-pyc
	$(MAKE) clean-build
	$(MAKE) clean-test
	$(MAKE) stop-docker

cleanall:         # Deep clean, including docker system prune if docker is used, venv, etc.
	$(MAKE) clean
	$(MAKE) clean-cache
	$(MAKE) clean-docs
	$(MAKE) clean-docker
	$(MAKE) novenv

build:            # TODO: Document here what build means for this repo
	$(NOTIMPLEMENTED)

test:             # Execute tests
	@$(VENV) pytest --version
	$(NOTIMPLEMENTED)

release:          # Create a branch and tag for VERSION on pure code repositories, publish to package repository for packaged software
	@$(MAKE) release-tag
	$(NOTIMPLEMENTED)

rc:               # tag release candidate for CI/CD
	$(NOTIMPLEMENTED)

releasecandidate: # alias for rc
	@$(MAKE) rc

# TODO: Add better reset handling
git-reset:        # Reset git repository to HEAD
	@git reset --hard origin/master


## Release
# Check current version against released versions
## Autobump --> Variable AUTOBUMP_LEVEL = none, fix, minor. (Assume major version changes are breaking and should be handled by human)
release-tag:
	$(NOTIMPLEMENTED)

release-pypi:
	$(NOTIMPLEMENTED)

release-docker:
	$(NOTIMPLEMENTED)

# Ops Requirements
venv:             # Create and use local virtul environment
venv: venv/py3
venv/py3:
	@$(MAKE) -C venv enable

novenv:           # Remove local virtualenvironment and delegate dependencies management to invoker
	@$(MAKE) -C venv disable

update-venv:      # Update venv with requirements
	@$(MAKE) -C venv enable

# General Docker Compose Targets
start-docker:     # Start the compose environment
	@docker compose up -d

stop-docker:      # Stop running compose deployments
	@docker-compose stop --timeout 60

clean-docker:     # Clean up Docker
	@docker-compose down --rmi all --remove-orphans --volumes --timeout 30
	@docker system prune --all --volumes --force

# Repository Specific Targets

.PHONY: clean-cache clean-docs clean-build clean-pyc clean-test

## remove local cache (?)
clean-cache:
	rm -fr .work/*

## remove docs
clean-docs:
	@$(MAKE) -C docs clean

## remove build artifacts
clean-build: 
	rm -fr build/
	rm -fr dist/
	rm -fr .eggs/
	find . -name '*.egg-info' -exec rm -fr {} +
	find . -name '*.egg' -exec rm -f {} +

## remove Python file artifacts
clean-pyc:
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +

## remove test and coverage artifacts
clean-test: 
	rm -fr .tox/
	rm -f .coverage
	rm -fr htmlcov/
	rm -fr .pytest_cache