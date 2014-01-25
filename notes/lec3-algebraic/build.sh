#!/bin/bash
pandoc ./README.md --latex-engine=xelatex -t latex -o "lecture3.pdf"
