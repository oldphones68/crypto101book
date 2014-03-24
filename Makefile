PBM_FILES := $(shell find Illustrations/ -type f -name '*.pbm')
RENDERED_PBM_FILES = $(patsubst %.pbm,%.pdf,${PBM_FILES})

SVG_FILES := $(shell find Illustrations/ -type f -name '*.svg')
RENDERED_SVG_FILES = $(patsubst %.svg,%.pdf,${SVG_FILES})

MP_FILES := $(shell find Illustrations/ -type f -name '*.mp')
RENDERED_MP_FILES = $(patsubst %.mp,%.pdf,${MP_FILES})

.PHONY: all clean

all: Crypto101.pdf

Crypto101.pdf: ${RENDERED_PBM_FILES} ${RENDERED_SVG_FILES} Crypto101.tex Header.tex Glossary.tex Crypto101.bib
	latexmk -bibtex -pdf -gg Crypto101.tex

Crypto101.tex: Crypto101.org
	emacs -Q --batch --file Crypto101.org --eval "(progn (setq org-confirm-babel-evaluate nil) (org-latex-export-to-latex))"

%.pdf: %.svg
	inkscape $< --export-pdf=$@

%.pdf: %.pbm
	potrace -b pdf $<

clean:
	git clean -fdx
