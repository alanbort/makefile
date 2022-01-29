# Set up Virtual Environment

.PHONY: enable disable

enable:
	@virtualenv py3
	@. py3/bin/activate && pip install --upgrade pip
	@. py3/bin/activate && \
	if [ -f ../requirements.txt ]; then \
		pip install --requirement ../requirements.txt; \
	fi
	@. py3/bin/activate && \
	if [ -f ../requirements-dev.txt ]; then \
		pip install --requirement ../requirements-dev.txt; \
	fi

disable:
	rm -fR py3