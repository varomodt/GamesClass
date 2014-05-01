#!/bin/bash
pandoc ./README.md --latex-engine=xelatex -t latex -o "lecture12.pdf"
