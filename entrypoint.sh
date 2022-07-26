#!/usr/bin/env bash

set -eu

VERSION=$(vtex-e2e --version)
echo ::notice title=VTEX Toolbelt version in use::$VERSION