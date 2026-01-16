#!/bin/bash
# fetch-source.sh - Fetch and cache a single source
# Usage: ./fetch-source.sh <source-url> [output-path]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"
CACHE_DIR="$SKILL_DIR/cache"
REGISTRY="$SKILL_DIR/sources/registry.json"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

usage() {
    cat << EOF
Usage: $0 <source-url> [output-path]

Fetch a source URL and cache it locally.

Arguments:
  source-url    URL to fetch (supports GitHub raw, web pages)
  output-path   Optional: Override cache path

Examples:
  $0 https://www.anthropic.com/engineering/claude-code-best-practices
  $0 https://raw.githubusercontent.com/anthropics/claude-code/main/CHANGELOG.md
  $0 https://code.claude.com/docs/en/hooks.md

EOF
    exit 1
}

# Determine cache path from URL
get_cache_path() {
    local url="$1"
    local path=""

    case "$url" in
        *anthropic.com/engineering/*)
            local slug=$(echo "$url" | sed 's|.*/engineering/||' | sed 's|[?#].*||')
            path="$CACHE_DIR/blog/${slug}.md"
            ;;
        *anthropic.com/news/*)
            local slug=$(echo "$url" | sed 's|.*/news/||' | sed 's|[?#].*||')
            path="$CACHE_DIR/news/${slug}.md"
            ;;
        *code.claude.com/docs/*)
            local slug=$(echo "$url" | sed 's|.*/docs/en/||' | sed 's|[?#].*||')
            path="$CACHE_DIR/docs/code-claude-com/${slug}"
            ;;
        *docs.anthropic.com/*)
            local slug=$(echo "$url" | sed 's|.*/docs/||' | sed 's|[?#].*||')
            path="$CACHE_DIR/docs/anthropic/${slug}.md"
            ;;
        *github.com/anthropics/*)
            local repo_and_path=$(echo "$url" | sed 's|.*github.com/anthropics/||')
            path="$CACHE_DIR/github/${repo_and_path}"
            ;;
        *raw.githubusercontent.com/anthropics/*)
            local repo_and_path=$(echo "$url" | sed 's|.*githubusercontent.com/anthropics/||' | sed 's|/main/|/|' | sed 's|/master/|/|')
            path="$CACHE_DIR/github/${repo_and_path}"
            ;;
        *gist.github.com/*)
            local gist_id=$(echo "$url" | grep -oE '[a-f0-9]{32}')
            path="$CACHE_DIR/community/gist-${gist_id}.md"
            ;;
        *agentskills.io/*)
            local slug=$(echo "$url" | sed 's|.*agentskills.io/||' | sed 's|[?#].*||')
            [[ -z "$slug" || "$slug" == "/" ]] && slug="home"
            path="$CACHE_DIR/agentskills/${slug}.md"
            ;;
        *github.com/agentskills/*)
            local repo_and_path=$(echo "$url" | sed 's|.*github.com/agentskills/||')
            path="$CACHE_DIR/github/agentskills/${repo_and_path}"
            ;;
        *raw.githubusercontent.com/agentskills/*)
            local repo_and_path=$(echo "$url" | sed 's|.*githubusercontent.com/agentskills/||' | sed 's|/main/|/|' | sed 's|/master/|/|')
            path="$CACHE_DIR/github/agentskills/${repo_and_path}"
            ;;
        *)
            log_error "Unknown URL pattern: $url"
            return 1
            ;;
    esac

    echo "$path"
}

# Fetch URL content
fetch_url() {
    local url="$1"
    local output="$2"

    # Create parent directory
    mkdir -p "$(dirname "$output")"

    # Use curl to fetch
    if curl -sSL --fail "$url" -o "$output.tmp" 2>/dev/null; then
        mv "$output.tmp" "$output"
        log_info "Cached: $output"
        return 0
    else
        rm -f "$output.tmp"
        log_error "Failed to fetch: $url"
        return 1
    fi
}

# Convert HTML to markdown (basic)
html_to_markdown() {
    local input="$1"
    local output="$2"

    # Check if file looks like HTML
    if head -1 "$input" | grep -qi "<!DOCTYPE\|<html"; then
        # Try using pandoc if available
        if command -v pandoc &> /dev/null; then
            pandoc -f html -t markdown -o "$output" "$input"
            rm "$input"
            log_info "Converted HTML to Markdown"
        else
            # Basic HTML stripping fallback
            sed -e 's/<[^>]*>//g' -e 's/&nbsp;/ /g' -e 's/&amp;/\&/g' "$input" > "$output"
            rm "$input"
            log_warn "Basic HTML conversion (install pandoc for better results)"
        fi
    else
        mv "$input" "$output"
    fi
}

# Add metadata header to cached file
add_metadata() {
    local file="$1"
    local url="$2"
    local date=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    local temp=$(mktemp)
    cat > "$temp" << EOF
---
source_url: $url
cached_at: $date
skill: claude-awareness-skill
---

EOF
    cat "$file" >> "$temp"
    mv "$temp" "$file"
}

# Main
main() {
    if [[ $# -lt 1 ]]; then
        usage
    fi

    local url="$1"
    local output="${2:-}"

    # Determine output path
    if [[ -z "$output" ]]; then
        output=$(get_cache_path "$url") || exit 1
    fi

    log_info "Fetching: $url"
    log_info "Target: $output"

    # Fetch the content
    if fetch_url "$url" "$output"; then
        # Add metadata header
        add_metadata "$output" "$url"

        # Update registry status (would need jq)
        log_info "Successfully cached"
        echo "$output"
    else
        exit 1
    fi
}

main "$@"
