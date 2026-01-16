#!/bin/bash
# sync-skill.sh - Generic sync script for all skills
# Usage: ./sync-skill.sh <skill-dir> [--force] [--dry-run]
#
# Reads sync.json from skill directory and handles:
# - Single URL sources (fetches and updates target file)
# - Registry-based sources (delegates to skill's sync script)

set -euo pipefail

# Colors (disabled in CI)
if [ -t 1 ] && [ "${CI:-}" != "true" ]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    NC='\033[0m'
else
    RED='' GREEN='' YELLOW='' BLUE='' NC=''
fi

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }
log_change() { echo -e "${BLUE}[CHANGE]${NC} $1"; }

# Parse arguments
SKILL_DIR=""
FORCE=false
DRY_RUN=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --force) FORCE=true; shift ;;
        --dry-run) DRY_RUN=true; shift ;;
        --help|-h)
            cat << EOF
Usage: $0 <skill-dir> [options]

Sync skill documentation from upstream sources.

Options:
  --force      Force sync even if cached
  --dry-run    Check for changes without modifying files
  --help       Show this help

Examples:
  $0 skills/umbrel-app
  $0 skills/claude-code-expert --force
  $0 skills/umbrel-app --dry-run
EOF
            exit 0
            ;;
        *)
            if [ -z "$SKILL_DIR" ]; then
                SKILL_DIR="$1"
            fi
            shift
            ;;
    esac
done

if [ -z "$SKILL_DIR" ]; then
    log_error "Skill directory is required"
    echo "Usage: $0 <skill-dir> [--force] [--dry-run]"
    exit 1
fi

# Resolve to absolute path
SKILL_DIR="$(cd "$SKILL_DIR" && pwd)"
MANIFEST="$SKILL_DIR/sync.json"

if [ ! -f "$MANIFEST" ]; then
    log_error "sync.json not found in $SKILL_DIR"
    exit 1
fi

# Check dependencies
check_deps() {
    if ! command -v jq &> /dev/null; then
        log_error "jq is required but not installed"
        exit 1
    fi
    if ! command -v curl &> /dev/null; then
        log_error "curl is required but not installed"
        exit 1
    fi
}

# Check if file needs refresh based on age
needs_refresh() {
    local cache_file="$1"
    local max_age_days="${2:-14}"

    if [[ ! -f "$cache_file" ]]; then
        return 0  # Needs fetch
    fi

    if [[ "$FORCE" == "true" ]]; then
        return 0  # Force refresh
    fi

    # Cross-platform file age check
    local file_mtime
    if [[ "$OSTYPE" == "darwin"* ]]; then
        file_mtime=$(stat -f %m "$cache_file" 2>/dev/null || echo 0)
    else
        file_mtime=$(stat -c %Y "$cache_file" 2>/dev/null || echo 0)
    fi

    local file_age=$(( ( $(date +%s) - file_mtime ) / 86400 ))
    if [[ $file_age -gt $max_age_days ]]; then
        return 0  # Too old
    fi

    return 1  # Fresh enough
}

# Fetch a single URL source
fetch_url_source() {
    local url="$1"
    local target="$2"
    local cache_dir="$3"
    local freshness_days="${4:-14}"

    local cache_file="$cache_dir/$(basename "$target").upstream"
    mkdir -p "$cache_dir"

    if ! needs_refresh "$cache_file" "$freshness_days"; then
        log_info "Fresh: $url (skipping)"
        return 0
    fi

    log_info "Fetching: $url"

    local temp_file=$(mktemp)
    if curl -sSL --fail "$url" -o "$temp_file"; then
        # Add metadata header
        local fetch_date=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
        {
            echo "---"
            echo "source_url: $url"
            echo "fetched_at: $fetch_date"
            echo "---"
            echo ""
            cat "$temp_file"
        } > "$cache_file"

        rm -f "$temp_file"
        log_info "Cached: $(basename "$cache_file")"

        # Compare with target and detect changes
        if [ -f "$SKILL_DIR/$target" ]; then
            # Extract content for comparison (skip metadata headers)
            local upstream_content=$(tail -n +6 "$cache_file" | head -100)
            local target_content=$(head -100 "$SKILL_DIR/$target")

            # Simple diff check for key patterns
            local changes=()

            # Check for new environment variables
            local new_vars=$(grep -oE '\$APP_[A-Z_]+' "$cache_file" | sort -u | \
                comm -23 - <(grep -oE '\$APP_[A-Z_]+' "$SKILL_DIR/$target" 2>/dev/null | sort -u) 2>/dev/null || true)
            if [ -n "$new_vars" ]; then
                for var in $new_vars; do
                    log_change "New environment variable: $var"
                done
            fi

            # Check for version changes
            local upstream_version=$(grep -oE 'manifestVersion[: ]+[0-9.]+' "$cache_file" | head -1 || echo "")
            local target_version=$(grep -oE 'manifestVersion[: ]+[0-9.]+' "$SKILL_DIR/$target" | head -1 || echo "")
            if [ "$upstream_version" != "$target_version" ] && [ -n "$upstream_version" ]; then
                log_change "manifestVersion changed: $target_version -> $upstream_version"
            fi
        fi

        return 0
    else
        log_error "Failed to fetch: $url"
        rm -f "$temp_file"
        return 1
    fi
}

# Handle registry-based sync (delegate to skill script)
sync_registry() {
    local sync_script="$1"
    local full_script="$SKILL_DIR/$sync_script"

    if [ ! -f "$full_script" ]; then
        log_error "Sync script not found: $full_script"
        return 1
    fi

    log_info "Running skill sync script: $sync_script"

    local args=""
    if [ "$FORCE" = "true" ]; then
        args="$args --force"
    fi

    chmod +x "$full_script"
    cd "$SKILL_DIR"

    if [ "$DRY_RUN" = "true" ]; then
        # For dry-run, use check-updates if available
        local check_script="${full_script%/*}/check-updates.sh"
        if [ -f "$check_script" ]; then
            chmod +x "$check_script"
            "$check_script" --verbose || true
        else
            log_info "Dry run: would run $sync_script"
        fi
    else
        "$full_script" $args
    fi
}

# Update sync.json version (patch bump)
bump_version() {
    local current_version=$(jq -r '.version' "$MANIFEST")
    local major minor patch

    IFS='.' read -r major minor patch <<< "$current_version"
    patch=$((patch + 1))
    local new_version="$major.$minor.$patch"

    if [ "$DRY_RUN" = "true" ]; then
        log_info "Would bump version: $current_version -> $new_version"
    else
        local temp=$(mktemp)
        jq --arg v "$new_version" '.version = $v' "$MANIFEST" > "$temp"
        mv "$temp" "$MANIFEST"
        log_info "Bumped version: $current_version -> $new_version"
    fi

    echo "$new_version"
}

# Main sync logic
main() {
    check_deps

    local skill_name=$(jq -r '.name' "$MANIFEST")
    local source_type=$(jq -r '.sources' "$MANIFEST")

    log_info "Syncing skill: $skill_name"
    log_info "Skill directory: $SKILL_DIR"
    log_info "Dry run: $DRY_RUN"
    log_info "Force: $FORCE"

    local had_changes=false

    if [ "$source_type" = "registry" ]; then
        # Registry-based sync (claude-code-expert)
        local sync_script=$(jq -r '.sync_script' "$MANIFEST")
        sync_registry "$sync_script"

        # Check if state.json was modified
        if ! git diff --quiet "$SKILL_DIR" 2>/dev/null; then
            had_changes=true
        fi
    else
        # URL-based sources (umbrel-app)
        local cache_dir="$SKILL_DIR/$(jq -r '.cache_dir // ".cache"' "$MANIFEST")"
        local freshness_days=$(jq -r '.freshness_days // 14' "$MANIFEST")

        jq -c '.sources[]' "$MANIFEST" | while read -r source; do
            local url=$(echo "$source" | jq -r '.url')
            local target=$(echo "$source" | jq -r '.target')
            local source_freshness=$(echo "$source" | jq -r ".freshness_days // $freshness_days")

            fetch_url_source "$url" "$target" "$cache_dir" "$source_freshness"
        done

        # Check for changes
        if ! git diff --quiet "$SKILL_DIR" 2>/dev/null; then
            had_changes=true
        fi
    fi

    # Output summary for CI
    if [ "$had_changes" = "true" ]; then
        log_info "Changes detected in $skill_name"
        echo "has_changes=true"
    else
        log_info "No changes detected in $skill_name"
        echo "has_changes=false"
    fi

    log_info "Sync complete: $skill_name"
}

main
