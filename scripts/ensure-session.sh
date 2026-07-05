#!/usr/bin/env bash
# ensure-session.sh — guarantee a usable SettleMesh session before any skill runs.
#
# The #1 activation-funnel death-point is an agent installing a skill, hitting an
# auth error on the first call, and STOPPING to ask the human to "run settlemesh
# login manually". This script (and the matching instruction in every SKILL.md)
# removes that dead-stop: it self-drives the one-time device-code login.
#
# Behavior:
#   1. If `settlemesh whoami` succeeds, a session already exists -> done.
#   2. If SETTLE_API_KEY is set (headless/CI), that key is used -> done.
#   3. Otherwise run `settlemesh login`, which opens the browser for a ONE-TIME
#      human approval and polls until approved, then caches the session.
#
# The single browser approval is the only human step. Keep an explicit human
# confirmation only for spending / credential-lending actions (fail-closed) —
# never for read-only discovery.
set -euo pipefail

if ! command -v settlemesh >/dev/null 2>&1; then
  echo "installing the SettleMesh CLI (npm i -g settlemesh)..." >&2
  npm install -g settlemesh@latest >&2
fi

if settlemesh whoami >/dev/null 2>&1; then
  exit 0
fi

if [ -n "${SETTLE_API_KEY:-}" ]; then
  # A headless key is present; the CLI/MCP will authenticate with it.
  exit 0
fi

echo "No SettleMesh session yet — starting a one-time login (approve in the browser)..." >&2
settlemesh login
