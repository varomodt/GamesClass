#!/bin/bash
pandoc ./README.md --latex-engine=xelatex -t latex -o "lecture7.pdf"
