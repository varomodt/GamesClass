#!/bin/bash
pandoc ./README.md --latex-engine=xelatex -t latex -o "lecture1.pdf"
