#!/bin/bash
set -euo pipefail

echo ""
echo "# [Build] Running  Testing"
echo "Install pip requirements.txt"
pip install -r dev_requirements.txt
echo "Run linting"
flake8 --max-line-length=119 --statistics --show-source
echo "Run Code Coverage"
coverage run -m unittest
coverage report
