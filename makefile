# Created by G. Peter Lepage (Cornell University) on 2008-02-12.
# Copyright (c) 2008-2015 G. Peter Lepage. 
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version (see <http://www.gnu.org/licenses/>).
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

PIP = pip
PYTHON = python
PYTHONVERSION = python`python -c 'import platform; print(platform.python_version())'`

install : 
	$(PIP) install . --user

# $(PYTHON) setup.py install --user --record files-gvar.$(PYTHONVERSION)

install-sys : 		
	$(PIP) install . 

# $(PYTHON) setup.py install --record files-gvar.$(PYTHONVERSION)

uninstall :			# mostly works (may leave some empty directories)
	$(PIP) uninstall gvar 

# - cat files-gvar.$(PYTHONVERSION) | xargs rm -rf
# - cat files-gdev.$(PYTHONVERSION) | xargs rm -rf

install-gdev :
	$(PYTHON) gdev-setup.py install --user --record files-gdev.$(PYTHONVERSION)

install-gdev-sys :
	$(PYTHON) gdev-setup.py install --record files-gdev.$(PYTHONVERSION)

doc-html:
	rm -rf doc/html; sphinx-build -b html doc/source doc/html

doc-pdf:
	rm -rf doc/gvar.pdf
	sphinx-build -b latex doc/source doc/latex
	cd doc/latex; make gvar.pdf; mv gvar.pdf ..

doc-zip doc.zip:
	cd doc/html; zip -r doc *; mv doc.zip ../..

doc-all: doc-html doc-pdf doc-zip

sdist:			# source distribution
	$(PYTHON) setup.py sdist

.PHONY: tests

tests test-all:
	@echo 'N.B. Some tests involve random numbers and so fail occasionally'
	@echo '     (less than 1 in 100 times) due to multi-sigma fluctuations.'
	@echo '     Run again if any test fails.'
	@echo ''
	$(PYTHON) -m unittest discover

run-examples:
	$(MAKE) -C examples PYTHON=$(PYTHON) run

register-pypi:
	python setup.py register # use only once, first time

upload-pypi:
	python setup.py sdist upload

upload-git:
	make doc-all
	git commit -a -m "prep for upload"
	git push origin master

clean:
	rm -f -r build 
	rm -rf __pycache__
	rm -f *.so *.tmp *.pyc *.prof *.c .coverage doc.zip
	rm -f -r dist
	rm -f -r doc/build
	$(MAKE) -C doc/source clean
	$(MAKE) -C tests clean
	$(MAKE) -C examples clean


