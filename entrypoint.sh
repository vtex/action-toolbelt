#!/usr/bin/env bash

set -eu

VERSION=$(vtex-e2e version)
echo ::notice title=VTEX Toolbelt version::$VERSION
echo ::warning title=VTEX Toolbelt warning::$VERSION
