#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source $(eval echo $XDG_STATE_HOME/quickshell/.venv)/bin/activate
"$SCRIPT_DIR/find_regions.py" "$@"
deactivate