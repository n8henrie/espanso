# parse_deps.py
"""Quick script to find and parse all dependency versions in the workspace."""

import tomllib
from pathlib import Path
from collections import Counter
from pprint import pprint

cargo_tomls = list(p for p in Path(".").glob("**/Cargo.toml") if len(p.parents) > 1)
counter = Counter(
    # (name, str(version)) for  p in cargo_tomls for name, version in tomllib.loads(p.read_text())["dependencies"].items() if not ("path" in version or "workspace" in version))
    name for  p in cargo_tomls for name, version in tomllib.loads(p.read_text())["dependencies"].items() if not ("path" in version or "workspace" in version))

if __name__ == "__main__":
    pprint(counter)
