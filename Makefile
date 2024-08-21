PYTHON = python 
PYDOC  = pydoc 
PYLINT  = pylint
WROKDIR =  ./
TARGET = test.py
MODULE = test
PYCS = $(shell find . -name "*.pyc")
PYCACHE	= $(shell find . -name "__pycache__")
LINTRST	= pylintresult.txt
LINTRCF	= pylintrc.txt
ARCHIVE	= $(shell basename `pwd`)
UPLOAD_DIR="static/uploads"
ALL_PROGRAM = $(shell find . -name "*.py")


test:
	flask --app $(MODULE) --debug run

wipe: clean
	(cd ../ ; rm -f ./$(ARCHIVE).zip)

clean:
	@if [ -d ${UPLOAD_DIR} ] ; then rm -rf ${UPLOAD_DIR}/* ; fi
	@for each in ${PYCS} ; do echo "rm -f $${each}" ; rm -f $${each} ; done
	@for each in ${PYCACHE} ; do echo "rm -f $${each}" ; rm -rf $${each} ; done
	@if [ -e $(LINTRST) ] ; then echo "rm -f $(LINTRST)" ; rm -f $(LINTRST) ; fi
	@if [ -e ${MODULE}.db ] ; then rm -f ${MODULE}.db ; fi
	@find . -name ".DS_Store" -exec rm {} ";" -exec echo rm -f {} ";"
	@xattr -cr ./

zip: wipe
	(cd ../ ; zip -r ./$(ARCHIVE).zip ./$(ARCHIVE) -e ".DS_Store" )

lint:
	for each in ${ALL_PROGRAM} ; do ${PYLINT} $${each} ; done
