#!/usr/bin/env bash

set -eu

VERSION="$(vtex-e2e --version) [from https://github.com/$VTEX_TOOLBELT_GIT/tree/$VTEX_VTEX_TOOLBELT_BRANCH]"
echo ::notice title=Toolbelt version used::$VERSION