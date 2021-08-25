#!/usr/bin/env bash
set -euo pipefail

export DAPP_SOLC=$(which solc)
export DAPP_BUILD_OPTIMIZE=1
export DAPP_BUILD_OPTIMIZE_RUNS=999999

dapp test --verbosity 1
