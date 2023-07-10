#!/bin/bash

# -C          : Prevent overwriting files with output redirection
# -e          : Exit the script if any command returns a non-zero status
# -u          : Exit the script if an undefined variable is used
# -o pipefail : Change pipeline exit status to the last non-zero exit
#               code in the pipeline, or zero if all commands succeed
# -x          : (Optional) Enable command tracing for easier debugging
set -Ceuo pipefail

echo -e "Creating .github/renovate.json"
mkdir -p .github
echo '{ "extends": ["github>nozomiishii/renovate"] }' > .github/renovate.json

echo -e "All set! Your Renovate configuration has been set up successfully🎉"
