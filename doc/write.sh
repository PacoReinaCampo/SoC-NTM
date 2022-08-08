rm -f *.pdf
rm -f *.tex

pandoc BOOK.md -s -o SoC-NTM.pdf
pandoc BOOK.md -s -o SoC-NTM.tex
