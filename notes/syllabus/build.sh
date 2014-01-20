#!/bin/bash
pandoc ./README.md --latex-engine=xelatex -t latex -o "syllabus.pdf"
