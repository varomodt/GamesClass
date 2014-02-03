#!/bin/bash
pandoc ./README.md --latex-engine=xelatex -t latex -o "lecture6.pdf"
