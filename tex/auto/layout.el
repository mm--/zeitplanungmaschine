(TeX-add-style-hook
 "layout"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("memoir" "12pt" "landscape" "oneside")))
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("inputenc" "utf8")))
   (TeX-run-style-hooks
    "latex2e"
    "tex/utilities"
    "tex/styles"
    "tex/dates"
    "memoir"
    "memoir12"
    "tikz"
    "pifont"
    "inputenc"
    "import"
    "forloop"
    "fix-cm")
   (TeX-add-symbols
    '("drawpage" 6)
    "theyear"
    "themonth"
    "theday"
    "sideL"
    "sideR"
    "sideT"
    "sideB"
    "foldA"
    "foldB"
    "foldC"
    "foldM"
    "width"
    "height"
    "xshift")))

