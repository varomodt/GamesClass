#!/bin/bash
pandoc ./README.md --latex-engine=xelatex -t latex -o "lecture2.pdf"
