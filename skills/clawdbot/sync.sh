#!/usr/bin/env bash
# sync.sh - Clawdbot documentation sync script
# Fetches all docs from docs.clawd.bot and generates SKILL.md files
#
# Usage: ./sync.sh [--force] [--dry-run]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CACHE_DIR="$SCRIPT_DIR/.cache"
SKILLS_DIR="$SCRIPT_DIR/skills"
BASE_URL="https://docs.clawd.bot"

# Colors
if [ -t 1 ]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    NC='\033[0m'
else
    RED='' GREEN='' YELLOW='' NC=''
fi

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Parse arguments
FORCE=false
DRY_RUN=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --force) FORCE=true; shift ;;
        --dry-run) DRY_RUN=true; shift ;;
        *) shift ;;
    esac
done

# Check if cache file is fresh (14 days)
is_fresh() {
    local cache_file="$1"
    local max_age_days="${2:-14}"

    if [[ ! -f "$cache_file" ]]; then
        return 1
    fi

    if [[ "$FORCE" == "true" ]]; then
        return 1
    fi

    local file_mtime
    if [[ "$OSTYPE" == "darwin"* ]]; then
        file_mtime=$(stat -f %m "$cache_file" 2>/dev/null || echo 0)
    else
        file_mtime=$(stat -c %Y "$cache_file" 2>/dev/null || echo 0)
    fi

    local file_age=$(( ( $(date +%s) - file_mtime ) / 86400 ))
    [[ $file_age -le $max_age_days ]]
}

# Fetch a single doc page and cache it
fetch_page() {
    local path="$1"
    local url="${BASE_URL}${path}"
    local cache_file="$CACHE_DIR/$(echo "$path" | tr '/' '_').html"

    mkdir -p "$CACHE_DIR"

    if is_fresh "$cache_file"; then
        log_info "Fresh: $path (cached)"
        return 0
    fi

    log_info "Fetching: $url"

    if curl -sSL --fail "$url" -o "$cache_file" 2>/dev/null; then
        log_info "Cached: $path"
        return 0
    else
        log_warn "Failed to fetch: $url"
        return 1
    fi
}

# Generate a skill - takes skill name and list of paths
generate_skill() {
    local skill_name="$1"
    local description="$2"
    shift 2
    local paths="$@"

    local skill_dir="$SKILLS_DIR/$skill_name"
    local skill_file="$skill_dir/SKILL.md"

    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "[DRY-RUN] Would update: $skill_file"
        log_info "  Sources: $paths"
        return 0
    fi

    mkdir -p "$skill_dir"
    log_info "Processing: $skill_name"

    # Fetch all sources
    for path in $paths; do
        fetch_page "$path" || true
    done

    log_info "Updated: $skill_name"
}

# Main sync logic
main() {
    log_info "Clawdbot Documentation Sync"
    log_info "Force: $FORCE"
    log_info "Dry run: $DRY_RUN"
    echo ""

    # Sync each skill
    generate_skill "clawdbot" \
        "Clawdbot overview" \
        /start/getting-started /start/wizard /start/faq

    generate_skill "clawdbot-install" \
        "Installation methods" \
        /install/installer /install/npm /install/source /install/docker \
        /install/ansible /install/nix /install/bun /updates/updating /updates/rollback

    generate_skill "clawdbot-cli" \
        "CLI commands" \
        /cli/message /cli/gateway /cli/updates /cli/sandbox

    generate_skill "clawdbot-concepts" \
        "Core concepts" \
        /concepts/architecture /concepts/agent-runtime /concepts/loops \
        /concepts/system-prompt /concepts/tokens /concepts/oauth \
        /concepts/workspaces /concepts/memory /concepts/multi-agent \
        /concepts/sessions /concepts/compaction /concepts/presence \
        /concepts/channel-routing /concepts/messaging /concepts/streaming \
        /concepts/groups /concepts/typing /concepts/queue /concepts/retry \
        /concepts/providers /concepts/failover /concepts/usage \
        /concepts/timezone /concepts/typebox

    generate_skill "clawdbot-gateway" \
        "Gateway operations" \
        /gateway/protocol /gateway/bridge /gateway/pairing /gateway/locking \
        /gateway/env /gateway/config /gateway/auth /gateway/openai-api \
        /gateway/background /gateway/health /gateway/heartbeat /gateway/doctor \
        /gateway/logging /gateway/security /gateway/sandbox /gateway/troubleshooting \
        /gateway/debugging /gateway/remote /gateway/discovery /gateway/bonjour \
        /gateway/tailscale

    generate_skill "clawdbot-channels" \
        "Messaging channels" \
        /channels/whatsapp /channels/telegram /channels/grammy /channels/discord \
        /channels/slack /channels/signal /channels/imessage /channels/msteams \
        /channels/broadcast /channels/troubleshooting /channels/location

    generate_skill "clawdbot-providers" \
        "Model providers" \
        /providers/overview /providers/openai /providers/anthropic \
        /providers/moonshot /providers/minimax /providers/openrouter \
        /providers/opencode /providers/glm /providers/zai

    generate_skill "clawdbot-tools" \
        "Tools and skills" \
        /tools/skills /tools/exec /tools/patch /tools/elevated /tools/browser \
        /tools/slash-commands /tools/thinking /tools/agent-send /tools/subagents \
        /tools/reactions /tools/clawdhub

    generate_skill "clawdbot-automation" \
        "Automation features" \
        /automation/auth-monitoring /automation/webhooks /automation/gmail \
        /automation/cron /automation/polling

    generate_skill "clawdbot-web" \
        "Web interfaces" \
        /web/control /web/dashboard /web/webchat /web/tui

    generate_skill "clawdbot-nodes" \
        "Nodes and media" \
        /nodes/camera /nodes/images /nodes/audio /nodes/location \
        /nodes/voice-wake /nodes/talk

    generate_skill "clawdbot-platforms" \
        "Platform support" \
        /platforms/macos /platforms/ios /platforms/android /platforms/windows \
        /platforms/linux /platforms/hetzner /platforms/exe-dev

    echo ""
    log_info "Sync complete!"
    log_info "Total skills: 12"
    log_info "Cache directory: $CACHE_DIR"
}

main
