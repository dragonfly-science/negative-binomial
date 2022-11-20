DOCKER := docker.dragonfly.co.nz/dragonverse-22.04:2022-07-14

RUN ?= docker run -it --rm --net=host --user=$$(id -u):$$(id -g) -e RUN=  -v$$(pwd):/work -w /work $(DOCKER)

all: negative-binomial.pdf

%.pdf: %.tex
	$(RUN) xelatex $* 

.PRECIOUS: negative-binomial.tex
%.tex: %.rnw
	$(RUN) R CMD Sweave $<

clean:
	rm -f  *.log *.aux *.out *.bbl *.pdf *.blg *.bcf *.run.xml *.toc *-self.bib *.nav *.snm 
