#!/bin/bash
# sync-sources.sh - Sync all or selected sources from registry
# Usage: ./sync-sources.sh [--priority=N] [--category=CATEGORY] [--force]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"
CACHE_DIR="$SKILL_DIR/cache"
SOURCES_DIR="$SKILL_DIR/sources"
REGISTRY="$SOURCES_DIR/registry.json"
STATE="$SKILL_DIR/state.json"

# Colors (disabled in CI for cleaner logs)
if [ -t 1 ] && [ "${CI:-}" != "true" ]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    NC='\033[0m'
else
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    NC=''
fi

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }
log_header() { echo -e "\n${BLUE}=== $1 ===${NC}\n"; }

# Check dependencies
check_deps() {
    if ! command -v jq &> /dev/null; then
        log_error "jq is required but not installed. Install with: brew install jq"
        exit 1
    fi
    if ! command -v curl &> /dev/null; then
        log_error "curl is required but not installed"
        exit 1
    fi
}

# Parse arguments
PRIORITY=""
CATEGORY=""
FORCE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --priority=*)
            PRIORITY="${1#*=}"
            shift
            ;;
        --category=*)
            CATEGORY="${1#*=}"
            shift
            ;;
        --force)
            FORCE=true
            shift
            ;;
        --help|-h)
            cat << EOF
Usage: $0 [options]

Sync sources from the registry to local cache.

Options:
  --priority=N      Only sync sources with priority <= N (1=highest)
  --category=CAT    Only sync specific category (blog, docs, github, release, agentskills)
  --force           Force re-fetch even if cached
  --help            Show this help

Examples:
  $0                        # Sync all stale sources
  $0 --priority=1           # Only sync priority 1 sources
  $0 --category=blog        # Only sync blog posts
  $0 --force                # Force refresh all
EOF
            exit 0
            ;;
        *)
            log_error "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Check if source needs refresh based on freshness rules
needs_refresh() {
    local cache_file="$1"
    local max_age_days="${2:-14}"

    if [[ ! -f "$cache_file" ]]; then
        return 0  # Needs fetch
    fi

    if [[ "$FORCE" == "true" ]]; then
        return 0  # Force refresh
    fi

    # Check file age
    local file_age=$(( ( $(date +%s) - $(stat -f %m "$cache_file" 2>/dev/null || stat -c %Y "$cache_file" 2>/dev/null) ) / 86400 ))
    if [[ $file_age -gt $max_age_days ]]; then
        return 0  # Too old
    fi

    return 1  # Fresh enough
}

# Sync engineering blog posts
sync_blog() {
    log_header "Syncing Engineering Blog"

    local articles=$(jq -r '.domains["anthropic.com/engineering"].articles | keys[]' "$REGISTRY" 2>/dev/null || echo "")

    for article in $articles; do
        local url=$(jq -r ".domains[\"anthropic.com/engineering\"].articles[\"$article\"].url" "$REGISTRY")
        local cache_path=$(jq -r ".domains[\"anthropic.com/engineering\"].articles[\"$article\"].localCache" "$REGISTRY")
        local priority=$(jq -r ".domains[\"anthropic.com/engineering\"].articles[\"$article\"].priority // 2" "$REGISTRY")

        # Skip if priority filter doesn't match
        if [[ -n "$PRIORITY" && "$priority" -gt "$PRIORITY" ]]; then
            continue
        fi

        local full_cache="$SKILL_DIR/$cache_path"

        if needs_refresh "$full_cache" 7; then
            log_info "Fetching: $article"
            "$SCRIPT_DIR/fetch-source.sh" "$url" "$full_cache" || log_warn "Failed: $article"
        else
            log_info "Fresh: $article"
        fi
    done
}

# Sync documentation
sync_docs() {
    log_header "Syncing Documentation"

    # code.claude.com
    local base_url=$(jq -r '.domains["code.claude.com"].baseUrl' "$REGISTRY")
    local pages=$(jq -r '.domains["code.claude.com"].pages | keys[]' "$REGISTRY" 2>/dev/null || echo "")

    for page in $pages; do
        local url="${base_url}${page}"
        local cache_path=$(jq -r ".domains[\"code.claude.com\"].pages[\"$page\"].localCache" "$REGISTRY")
        local full_cache="$SKILL_DIR/$cache_path"

        if needs_refresh "$full_cache" 14; then
            log_info "Fetching: $page"
            "$SCRIPT_DIR/fetch-source.sh" "$url" "$full_cache" || log_warn "Failed: $page"
        else
            log_info "Fresh: $page"
        fi
    done
}

# Sync GitHub repositories
sync_github() {
    log_header "Syncing GitHub Repositories"

    local repos=$(jq -r '.domains["github.com/anthropics"].repositories | keys[]' "$REGISTRY" 2>/dev/null || echo "")

    for repo in $repos; do
        local repo_url=$(jq -r ".domains[\"github.com/anthropics\"].repositories[\"$repo\"].url" "$REGISTRY")
        local paths=$(jq -r ".domains[\"github.com/anthropics\"].repositories[\"$repo\"].paths | keys[]" "$REGISTRY" 2>/dev/null || echo "")

        for path in $paths; do
            local cache_path=$(jq -r ".domains[\"github.com/anthropics\"].repositories[\"$repo\"].paths[\"$path\"].localCache" "$REGISTRY")
            local full_cache="$SKILL_DIR/$cache_path"

            # Convert GitHub URL to raw URL
            local raw_url="https://raw.githubusercontent.com/anthropics/${repo}/main/${path}"

            if needs_refresh "$full_cache" 7; then
                log_info "Fetching: $repo/$path"
                "$SCRIPT_DIR/fetch-source.sh" "$raw_url" "$full_cache" || log_warn "Failed: $repo/$path"
            else
                log_info "Fresh: $repo/$path"
            fi
        done
    done
}

# Sync agentskills.io documentation
sync_agentskills() {
    log_header "Syncing Agent Skills Documentation"

    local pages=$(jq -r '.domains["agentskills.io"].pages | keys[]' "$REGISTRY" 2>/dev/null || echo "")

    for page in $pages; do
        local url=$(jq -r ".domains[\"agentskills.io\"].pages[\"$page\"].url" "$REGISTRY")
        local cache_path=$(jq -r ".domains[\"agentskills.io\"].pages[\"$page\"].localCache" "$REGISTRY")
        local full_cache="$SKILL_DIR/$cache_path"

        if needs_refresh "$full_cache" 14; then
            log_info "Fetching: agentskills.io/$page"
            "$SCRIPT_DIR/fetch-source.sh" "$url" "$full_cache" || log_warn "Failed: $page"
        else
            log_info "Fresh: agentskills.io/$page"
        fi
    done

    # Also sync agentskills GitHub repo
    local repo_url="https://raw.githubusercontent.com/agentskills/agentskills/main/README.md"
    local repo_cache="$CACHE_DIR/github/agentskills/README.md"

    if needs_refresh "$repo_cache" 7; then
        log_info "Fetching: agentskills/agentskills README"
        "$SCRIPT_DIR/fetch-source.sh" "$repo_url" "$repo_cache" || log_warn "Failed: agentskills README"
    else
        log_info "Fresh: agentskills README"
    fi
}

# Sync release notes (high priority, daily check)
sync_release_notes() {
    log_header "Syncing Release Notes"

    local url="https://docs.anthropic.com/en/release-notes/claude-code"
    local cache_path="$CACHE_DIR/docs/anthropic/release-notes/claude-code.md"

    if needs_refresh "$cache_path" 1; then
        log_info "Fetching: Claude Code Release Notes"
        "$SCRIPT_DIR/fetch-source.sh" "$url" "$cache_path" || log_warn "Failed to fetch release notes"
    else
        log_info "Fresh: Release Notes"
    fi
}

# Update state.json with sync timestamp
update_state() {
    local now=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    if [[ -f "$STATE" ]]; then
        local temp=$(mktemp)
        jq --arg now "$now" '.documentation.official.claudeCode.lastChecked = $now' "$STATE" > "$temp"
        mv "$temp" "$STATE"
        log_info "Updated state.json lastChecked: $now"
    fi
}

# Summary
print_summary() {
    log_header "Sync Complete"

    local cached_count=$(find "$CACHE_DIR" -type f -name "*.md" | wc -l | tr -d ' ')
    log_info "Total cached files: $cached_count"

    # Show recently updated
    log_info "Recently updated files:"
    find "$CACHE_DIR" -type f -name "*.md" -mtime -1 -exec basename {} \; 2>/dev/null | head -5 | while read f; do
        echo "  - $f"
    done
}

# Main
main() {
    check_deps

    log_info "Starting source sync..."
    log_info "Registry: $REGISTRY"
    log_info "Cache: $CACHE_DIR"

    if [[ -n "$CATEGORY" ]]; then
        case "$CATEGORY" in
            blog) sync_blog ;;
            docs) sync_docs ;;
            github) sync_github ;;
            release) sync_release_notes ;;
            agentskills) sync_agentskills ;;
            *) log_error "Unknown category: $CATEGORY"; exit 1 ;;
        esac
    else
        # Sync all categories
        sync_release_notes  # Always sync release notes first
        sync_blog
        sync_docs
        sync_github
        sync_agentskills
    fi

    update_state
    print_summary
}

main
