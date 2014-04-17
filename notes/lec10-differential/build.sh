#!/bin/bash
pandoc ./README.md --latex-engine=xelatex -t latex -o "lecture10.pdf"
