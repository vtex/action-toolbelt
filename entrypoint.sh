#!/usr/bin/env bash

set -eu

VERSION="$(vtex-e2e --version) [from https://github.com/$VTEX_GIT/tree/$VTEX_BRANCH]"
echo ::notice title=Toolbelt version used::$VERSION