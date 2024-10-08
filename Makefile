PYTHON = python 
PYDOC  = pydoc 
PYLINT  = pylint
WROKDIR =  ./
TARGET = my_app.py
MODULE = my_app
PYCS = $(shell find . -name "*.pyc")
PYCACHE	= $(shell find . -name "__pycache__")
LINTRST	= pylintresult.txt
LINTRCF	= pylintrc.txt
ARCHIVE	= $(shell basename `pwd`)
UPLOAD_DIR="static/uploads"
ALL_PROGRAM = $(shell find . -name "*.py")

gunicorn:
	gunicorn -w 4 -b 0.0.0.0:5000 'my_app:app'

test:
	flask --app $(MODULE) --debug run

wipe: clean
	(cd ../ ; rm -f ./$(ARCHIVE).zip)

clean:
	@if [ -d ${UPLOAD_DIR} ] ; then rm -rf ${UPLOAD_DIR}/* ; fi
	@for each in ${PYCS} ; do echo "rm -f $${each}" ; rm -f $${each} ; done
	@for each in ${PYCACHE} ; do echo "rm -f $${each}" ; rm -rf $${each} ; done
	@if [ -e $(LINTRST) ] ; then echo "rm -f $(LINTRST)" ; rm -f $(LINTRST) ; fi
	@if [ -e test.db ] ; then rm -f test.db ; fi
	@find . -name ".DS_Store" -exec rm {} ";" -exec echo rm -f {} ";"
	@xattr -cr ./

zip: wipe
	(cd ../ ; zip -r ./$(ARCHIVE).zip ./$(ARCHIVE) -e ".DS_Store" )

lint:
	for each in ${ALL_PROGRAM} ; do ${PYLINT} $${each} ; done
