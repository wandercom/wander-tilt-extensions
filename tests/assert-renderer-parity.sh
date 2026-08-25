#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
readonly REPO_ROOT

python3 - "$REPO_ROOT/wtpl/Tiltfile" "$REPO_ROOT/bin/wtpl" <<'PY'
import re
import sys
from pathlib import Path

tiltfile = Path(sys.argv[1]).read_text(encoding="utf-8")
script = Path(sys.argv[2]).read_text(encoding="utf-8")

tilt_match = re.search(r"    program = '''\n(.*?)\n    '''", tiltfile, re.DOTALL)
script_match = re.search(r"readonly PROGRAM='(.*?)'\n\nusage", script, re.DOTALL)

if tilt_match is None or script_match is None:
    raise SystemExit("could not extract both renderer programs")

normalize = lambda program: "\n".join(line.strip() for line in program.splitlines()).strip()
if normalize(tilt_match.group(1)) != normalize(script_match.group(1)):
    raise SystemExit("extension and CLI renderer programs differ")
PY
