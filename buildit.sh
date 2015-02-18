#!/bin/bash
# Josh Moller-Mara

./read-org-agenda.R
./ledger-generate.R

latexmk -pdf -bibtex zeitplanungmaschine.tex
