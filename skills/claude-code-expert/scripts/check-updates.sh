#!/bin/bash
# check-updates.sh - Quick check for documentation updates
# Usage: ./check-updates.sh [--verbose]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"
CACHE_DIR="$SKILL_DIR/cache"
SOURCES_DIR="$SKILL_DIR/sources"
STATE="$SKILL_DIR/state.json"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

VERBOSE=false
[[ "${1:-}" == "--verbose" ]] && VERBOSE=true

# Get last check date from state
get_last_check() {
    if [[ -f "$STATE" ]]; then
        jq -r '.documentation.official.claudeCode.lastChecked // "never"' "$STATE"
    else
        echo "never"
    fi
}

# Calculate days since last check
days_since_check() {
    local last_check=$(get_last_check)
    if [[ "$last_check" == "never" ]]; then
        echo "never"
        return
    fi

    local last_ts=$(date -j -f "%Y-%m-%dT%H:%M:%SZ" "$last_check" "+%s" 2>/dev/null || date -d "$last_check" "+%s" 2>/dev/null || echo 0)
    local now_ts=$(date +%s)
    local days=$(( (now_ts - last_ts) / 86400 ))
    echo "$days"
}

# Count cached files by category
count_cached() {
    local category="$1"
    find "$CACHE_DIR/$category" -type f -name "*.md" 2>/dev/null | wc -l | tr -d ' '
}

# Check freshness
check_freshness() {
    local days=$(days_since_check)

    echo -e "\n${BLUE}=== Documentation Freshness ===${NC}\n"

    if [[ "$days" == "never" ]]; then
        echo -e "${RED}Last check: Never${NC}"
        echo -e "${YELLOW}Recommendation: Run ./sync-sources.sh to fetch documentation${NC}"
    elif [[ "$days" -gt 14 ]]; then
        echo -e "${YELLOW}Last check: $days days ago${NC}"
        echo -e "${YELLOW}Recommendation: Documentation may be stale. Run ./sync-sources.sh${NC}"
    elif [[ "$days" -gt 7 ]]; then
        echo -e "${YELLOW}Last check: $days days ago${NC}"
        echo -e "${GREEN}Status: Documentation is reasonably fresh${NC}"
    else
        echo -e "${GREEN}Last check: $days days ago${NC}"
        echo -e "${GREEN}Status: Documentation is fresh${NC}"
    fi
}

# Show cache status
cache_status() {
    echo -e "\n${BLUE}=== Cache Status ===${NC}\n"

    echo "Category              | Cached Files"
    echo "----------------------|-------------"
    echo "Blog posts            | $(count_cached blog)"
    echo "News/Announcements    | $(count_cached news)"
    echo "code.claude.com docs  | $(count_cached docs/code-claude-com)"
    echo "docs.anthropic.com    | $(count_cached docs/anthropic)"
    echo "GitHub repositories   | $(count_cached github)"
    echo "Community             | $(count_cached community)"
    echo ""

    local total=$(find "$CACHE_DIR" -type f -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
    echo -e "Total cached: ${GREEN}$total${NC} files"
}

# Show stale files
stale_files() {
    echo -e "\n${BLUE}=== Stale Files (>14 days) ===${NC}\n"

    local stale=$(find "$CACHE_DIR" -type f -name "*.md" -mtime +14 2>/dev/null | wc -l | tr -d ' ')

    if [[ "$stale" -eq 0 ]]; then
        echo -e "${GREEN}No stale files${NC}"
    else
        echo -e "${YELLOW}$stale stale files:${NC}"
        find "$CACHE_DIR" -type f -name "*.md" -mtime +14 -exec basename {} \; 2>/dev/null | head -10 | while read f; do
            echo "  - $f"
        done
        [[ $stale -gt 10 ]] && echo "  ... and $(($stale - 10)) more"
    fi
}

# Show missing high-priority sources
missing_sources() {
    echo -e "\n${BLUE}=== Missing High-Priority Sources ===${NC}\n"

    local missing=0

    # Check for key blog posts
    for post in "claude-code-best-practices" "building-agents-sdk" "agent-skills"; do
        if [[ ! -f "$CACHE_DIR/blog/${post}.md" ]]; then
            echo -e "${RED}Missing: Blog - $post${NC}"
            ((missing++))
        fi
    done

    # Check for key docs
    for doc in "hooks" "sub-agents" "skills" "mcp"; do
        if [[ ! -f "$CACHE_DIR/docs/code-claude-com/${doc}.md" ]]; then
            echo -e "${RED}Missing: Docs - $doc${NC}"
            ((missing++))
        fi
    done

    # Check release notes
    if [[ ! -f "$CACHE_DIR/docs/anthropic/release-notes/claude-code.md" ]]; then
        echo -e "${RED}Missing: Release Notes${NC}"
        ((missing++))
    fi

    if [[ $missing -eq 0 ]]; then
        echo -e "${GREEN}All high-priority sources cached${NC}"
    else
        echo -e "\n${YELLOW}Run ./sync-sources.sh --priority=1 to fetch missing sources${NC}"
    fi
}

# Main
main() {
    echo -e "${BLUE}Claude Awareness Skill - Source Status${NC}"
    echo "========================================"

    check_freshness
    cache_status

    if [[ "$VERBOSE" == "true" ]]; then
        stale_files
        missing_sources
    fi

    echo -e "\n${BLUE}=== Quick Actions ===${NC}\n"
    echo "  ./sync-sources.sh              # Sync all stale sources"
    echo "  ./sync-sources.sh --priority=1 # Sync priority 1 only"
    echo "  ./sync-sources.sh --category=blog # Sync blog posts"
    echo "  ./check-updates.sh --verbose   # Detailed status"
    echo ""
}

main
