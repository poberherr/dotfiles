#!/usr/bin/env bash
# Toggle opencode openai auth between ChatGPT-Team oauth and API key (overflow).
# API key is fetched from 1Password on demand — never stored on disk by this script.
#
# Usage:
#   opencode-auth status         # show active auth type
#   opencode-auth to-api         # switch to API key (overflow when ChatGPT plan rate-limited)
#   opencode-auth to-oauth       # switch back to ChatGPT-Team oauth
#
# 1Password item: Employee vault > "ChatGPT - patrick opencode_m5 api token"
set -euo pipefail

AUTH_FILE="$HOME/.local/share/opencode/auth.json"
BACKUP_DIR="$HOME/.local/share/opencode/auth-backup"
OP_REF='op://Employee/pncgwe23vuz3kl52z52idafdty/password'

mkdir -p "$BACKUP_DIR"

current_type() {
    [[ -f "$AUTH_FILE" ]] || { echo "missing"; return; }
    python3 -c "
import json
try:
    d = json.load(open('$AUTH_FILE'))
    print(d.get('openai',{}).get('type','none'))
except Exception:
    print('parse-error')
"
}

cmd_status() {
    local t; t=$(current_type)
    echo "opencode openai auth: $t"
    if [[ -f "$BACKUP_DIR/oauth.json" ]]; then
        echo "  oauth backup: present  ($BACKUP_DIR/oauth.json)"
    fi
}

cmd_to_api() {
    local t; t=$(current_type)
    if [[ "$t" == "api" ]]; then
        echo "already on api key, nothing to do"; return
    fi
    if [[ "$t" == "oauth" ]]; then
        # Save oauth section so we can restore later without re-running login flow.
        python3 -c "
import json
d = json.load(open('$AUTH_FILE'))
json.dump({'openai': d['openai']}, open('$BACKUP_DIR/oauth.json','w'), indent=2)
"
        echo "backed up oauth -> $BACKUP_DIR/oauth.json"
    fi
    local key
    key=$(op read "$OP_REF") || { echo "1Password read failed"; exit 1; }
    python3 -c "
import json, os
p = '$AUTH_FILE'
d = json.load(open(p)) if os.path.exists(p) else {}
d['openai'] = {'type': 'api', 'key': '$key'}
json.dump(d, open(p,'w'), indent=2)
os.chmod(p, 0o600)
"
    echo "switched to: api"
}

cmd_to_oauth() {
    local t; t=$(current_type)
    if [[ "$t" == "oauth" ]]; then
        echo "already on oauth, nothing to do"; return
    fi
    if [[ ! -f "$BACKUP_DIR/oauth.json" ]]; then
        echo "no oauth backup found at $BACKUP_DIR/oauth.json"
        echo "run: opencode auth login openai   # to re-authenticate via ChatGPT"
        exit 1
    fi
    python3 -c "
import json, os
backup = json.load(open('$BACKUP_DIR/oauth.json'))
p = '$AUTH_FILE'
d = json.load(open(p)) if os.path.exists(p) else {}
d['openai'] = backup['openai']
json.dump(d, open(p,'w'), indent=2)
os.chmod(p, 0o600)
"
    echo "switched to: oauth"
}

case "${1:-status}" in
    status) cmd_status ;;
    to-api) cmd_to_api ;;
    to-oauth) cmd_to_oauth ;;
    *) echo "usage: $(basename "$0") {status|to-api|to-oauth}"; exit 2 ;;
esac
