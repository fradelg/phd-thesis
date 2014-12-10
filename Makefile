TARGET = rec3d
PANDOC = pandoc
GITBOOK = gitbook
OPTS = --mathjax --template=template.html
BIB = bibtex
BIBFILE = thesis.bib
BIBSTYLE = cad.csl
BIBOPTS = --biblio $(BIBFILE) -cls $(BIBSTYLE)

SERVER = 157.88.193.20
USER = fradelg
LOCALDIR = _book
FIGUREDIR = figures
REMOTEDIR = /home/fradelg/www/phd

SRC = $(shell find . -type f -name '*.md')
HTML1 = $(filter-out ./README.md, $(SRC))
HTML2 = $(filter-out ./SUMMARY.md, $(HTML1))
HTML = $(patsubst %.md, %.html, $(HTML2))

.PHONY: all

all: book $(HTML)

book: $(SRC)
	$(GITBOOK) build

$(TARGET).pdf: $(SOURCES)
	$(PANDOC) $(OPTS) $(BIBOPTS) -o $(TARGET).pdf $(SOURCES)

$(TARGET).html: $(SOURCES)
	$(PANDOC) $(OPTS) $(BIBOPTS) -o $(TARGET).html $(SOURCES)

$(TARGET).epub: $(SOURCES)
	$(PANDOC) $(OPTS) $(BIBOPTS) -o $(TARGET).epub $(SOURCES)

%.html: %.md
	@echo "Pandoc building for file $<"
	@$(PANDOC) $(OPTS) $(BIBOPTS) -o tmp.html $<
	@tail -n +371 tmp.html > tail.html
	@sed -i -ne '/<section/ {p; r tail.html' -e ':a; n; /<\/section>/ {p; b}; ba}; p' _book/$@
	@rm tail.html tmp.html

clean:
	rm -f $(LOCALDIR)

upload:
	rsync -rvzhe ssh $(LOCALDIR) $(USER)@$(SERVER):$(REMOTEDIR)
#	rsync -rvzhe ssh $(FIGUREDIR) $(USER)@$(SERVER):$(REMOTEDIR)/figures/
