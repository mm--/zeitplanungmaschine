# Zeitplanungmaschine Makefile
binaries=zeitplanungmaschine.pdf generated/testdates.tex generated/org-agenda.csv generated/finance-output.tex generated/week-agenda.pdf generated/reading-output.tex generated/front-page.pdf
mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))

all: clean zeitplanungmaschine.pdf

code1: code1.cc utilities.cc
	$(CXX) $^ -o $@

zeitplanungmaschine.pdf: generated/testdates.tex generated/org-agenda.csv generated/week-agenda.pdf generated/finance-output.tex generated/reading-output.tex generated/front-page.pdf
	latexmk -pdf -pdflatex="pdflatex -interactive=nonstopmode" -use-make zeitplanungmaschine.tex

generated/finance-output.tex:
	Rscript scripts/ledger-generate.R

generated/reading-output.tex:
	Rscript scripts/reading-per-day.R

generated/testdates.tex: generated/org-agenda.csv
	Rscript scripts/read-org-agenda.R

generated/week-agenda.pdf:
	wkhtmltopdf /home/jm3/agendas-org/week-agenda.html generated/week-agenda.pdf

generated/front-page.pdf:
	wkhtmltopdf --javascript-delay 1000 --page-size A8 html/front-page.html generated/front-page.pdf

generated/org-agenda.csv:
	emacsclient -e "(org-batch-agenda-csv-file \"z\" \"./generated/org-agenda.csv\")"

.PHONY: clean

clean:
	rm -f $(binaries)
