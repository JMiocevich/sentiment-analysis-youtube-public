#!/bin/bash
set -euo pipefail

# echo ""
# echo "# Building Services via SAM"
# It is not strictly needed to 'sam build' here and then 'sam deploy' in deploy.sh because 'sam deply' also builds.
# However, by building here it is easier to see where failures occur.
# Removed for pipeline - build occurs in build ac, cannot access SARs therefore fails.
# sam build \
#     --template-file infrastructure/master.yml


# Building lambda layer dependencies because SAM deploy does not work correctly - ignores BuildMethod
echo ""
echo "# [Build] Lambda layer dependencies"
targetDir=src/layer_base
find ${targetDir}/python/. ! -name ".gitignore" ! -name "." ! -name ".." -exec rm -rf {} +
python3 -m pip install -r ${targetDir}/requirements.txt -t ${targetDir}/python/
