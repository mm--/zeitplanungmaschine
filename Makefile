CXX = g++ -O2 -Wall

binaries=zeitplanungmaschine.pdf testdates.tex org-agenda.csv finance-output.tex week-agenda.pdf
mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))

all: clean zeitplanungmaschine.pdf

code1: code1.cc utilities.cc
	$(CXX) $^ -o $@

zeitplanungmaschine.pdf: testdates.tex org-agenda.csv week-agenda.pdf
	latexmk -pdf -pdflatex="pdflatex -interactive=nonstopmode" -use-make zeitplanungmaschine.tex

finance-output.tex:
	Rscript ledger-generate.R

testdates.tex: org-agenda.csv
	Rscript read-org-agenda.R

week-agenda.pdf:
	wkhtmltopdf /home/jm3/agendas-org/week-agenda.html week-agenda.pdf

org-agenda.csv:
	emacsclient -e "(org-batch-agenda-csv-file \"z\" \"./org-agenda.csv\")"

.PHONY: clean

clean:
	rm -f $(binaries)
