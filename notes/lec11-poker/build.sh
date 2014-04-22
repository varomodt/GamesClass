#!/bin/bash
pandoc ./README.md --latex-engine=xelatex -t latex -o "lecture11.pdf"
