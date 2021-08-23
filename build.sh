#!/usr/bin/env bash
set -euo pipefail

export DAPP_SOLC=$(which solc)
export DAPP_OPTIMIZE_BUILD=0
export DAPP_OPTIMIZE_BUILD_RUNS=999999

dapp test --verbosity 3
