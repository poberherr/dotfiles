#!/usr/bin/env bash
# Activate git hooks for this repository
set -euo pipefail

cd "$(dirname "$0")"
git config core.hooksPath .githooks
chmod +x .githooks/*
echo "Git hooks activated (.githooks/)"
