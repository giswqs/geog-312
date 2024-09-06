SHELL:= bash
PY:= python3.11
VENV:= .venv

vb:= $(VENV)/bin/

define vrun
	source $(vb)activate && $(1)
endef

.PHONY: requirements
.PHONY: clean

requirements: $(vb)pip requirements.txt
	$(call vrun,pip --require-virtualenv \
	  install --requirement=requirements.txt)

$(vb)pip: $(vb)activate
	$(call vrun,pip --require-virtualenv \
	  list --format=freeze \
	  |grep -oE '^[^=]+' \
	  |xargs pip install --upgrade)

$(vb)activate:
	$(PY) -m venv $(VENV)

clean:
	rm -fr $(VENV)
