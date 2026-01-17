#!/bin/bash
# sync-skill.sh - Generic sync script for all skills
# Usage: ./sync-skill.sh <skill-dir> [--force] [--dry-run]
#
# Reads sync.json from skill directory and handles:
# - Single URL sources (fetches and updates target file)
# - Registry-based sources (delegates to skill's sync script)
# - HTML content extraction via pandoc

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
SYNC_REPORT="$SKILL_DIR/sync-report.txt"

if [ ! -f "$MANIFEST" ]; then
    log_error "sync.json not found in $SKILL_DIR"
    exit 1
fi

# Initialize sync report
init_report() {
    echo "# Sync Report - $(date -Iseconds)" > "$SYNC_REPORT"
    echo "# Format: URL|STATUS|HTTP_CODE|TIMESTAMP" >> "$SYNC_REPORT"
}

# Add entry to sync report
report_entry() {
    local url="$1"
    local status="$2"
    local http_code="${3:-N/A}"
    echo "$url|$status|$http_code|$(date -Iseconds)" >> "$SYNC_REPORT"
}

# Check dependencies
check_deps() {
    local missing=()

    if ! command -v jq &> /dev/null; then
        missing+=("jq")
    fi
    if ! command -v curl &> /dev/null; then
        missing+=("curl")
    fi

    if [ ${#missing[@]} -gt 0 ]; then
        log_error "Missing required dependencies: ${missing[*]}"
        exit 1
    fi

    # Optional: pandoc for HTML extraction
    if ! command -v pandoc &> /dev/null; then
        log_warn "pandoc not installed - HTML extraction will use basic fallback"
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

# Fetch with retry and exponential backoff
fetch_with_retry() {
    local url="$1"
    local output_file="$2"
    local retries="${3:-3}"
    local delay=5
    local http_code

    for ((i=1; i<=retries; i++)); do
        # Fetch with HTTP code capture
        http_code=$(curl -sSL -w "%{http_code}" --fail -o "$output_file" "$url" 2>/dev/null) || http_code="000"

        # Check for success (2xx)
        if [[ "$http_code" =~ ^2[0-9][0-9]$ ]]; then
            echo "$http_code"
            return 0
        fi

        # Check for redirect (3xx) - curl -L should follow, but capture final code
        if [[ "$http_code" =~ ^3[0-9][0-9]$ ]]; then
            log_warn "Redirect detected for $url (HTTP $http_code)"
        fi

        # Check for client error (4xx) - don't retry
        if [[ "$http_code" =~ ^4[0-9][0-9]$ ]]; then
            log_error "Client error for $url (HTTP $http_code) - not retrying"
            echo "$http_code"
            return 1
        fi

        if [[ $i -lt $retries ]]; then
            log_warn "Attempt $i failed for $url (HTTP $http_code), retrying in ${delay}s..."
            sleep $delay
            delay=$((delay * 2))  # Exponential backoff
        fi
    done

    echo "$http_code"
    return 1
}

# Extract content from HTML using pandoc
extract_content() {
    local input_file="$1"
    local output_file="$2"

    if command -v pandoc &> /dev/null; then
        # Use pandoc to convert HTML to markdown
        pandoc -f html -t markdown --wrap=none "$input_file" -o "$output_file" 2>/dev/null

        # Clean up excessive whitespace
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' 's/^[[:space:]]*$//' "$output_file"
        else
            sed -i 's/^[[:space:]]*$//' "$output_file"
        fi
    else
        # Fallback: basic HTML tag stripping (not ideal)
        # Remove script and style tags and their content
        sed 's/<script[^>]*>.*<\/script>//g' "$input_file" | \
        sed 's/<style[^>]*>.*<\/style>//g' | \
        # Remove HTML tags
        sed 's/<[^>]*>//g' | \
        # Decode common HTML entities
        sed 's/&nbsp;/ /g; s/&amp;/\&/g; s/&lt;/</g; s/&gt;/>/g; s/&quot;/"/g' | \
        # Remove excessive blank lines
        cat -s > "$output_file"

        log_warn "Used basic HTML stripping - consider installing pandoc for better results"
    fi
}

# Validate fetched content
validate_content() {
    local file="$1"
    local source_type="${2:-raw}"

    # Check file exists and is not empty
    if [[ ! -s "$file" ]]; then
        log_error "Validation failed: File is empty"
        return 1
    fi

    # Check minimum content length (100 bytes)
    local size
    size=$(wc -c < "$file" | tr -d ' ')
    if [[ $size -lt 100 ]]; then
        log_error "Validation failed: Content too small ($size bytes)"
        return 1
    fi

    # For markdown targets, check it's not raw HTML
    if [[ "$file" == *.md ]]; then
        if head -5 "$file" | grep -q '<!DOCTYPE\|<html'; then
            log_error "Validation failed: File contains raw HTML instead of markdown"
            return 1
        fi
    fi

    return 0
}

# Fetch a single URL source
fetch_url_source() {
    local url="$1"
    local target="$2"
    local cache_dir="$3"
    local freshness_days="${4:-14}"
    local source_type="${5:-raw}"

    local cache_file="$cache_dir/$(basename "$target").upstream"
    mkdir -p "$cache_dir"
    mkdir -p "$(dirname "$SKILL_DIR/$target")"

    if ! needs_refresh "$cache_file" "$freshness_days"; then
        log_info "Fresh: $url (skipping)"
        report_entry "$url" "SKIPPED" "N/A"
        return 0
    fi

    log_info "Fetching: $url"

    local temp_file
    temp_file=$(mktemp)
    local temp_converted
    temp_converted=$(mktemp)

    # Fetch with retry
    local http_code
    if http_code=$(fetch_with_retry "$url" "$temp_file"); then
        # Handle content extraction based on type
        if [[ "$source_type" == "extract-content" ]]; then
            log_info "Extracting content from HTML..."
            extract_content "$temp_file" "$temp_converted"
            mv "$temp_converted" "$temp_file"
        fi

        # Validate content
        if ! validate_content "$temp_file" "$source_type"; then
            log_error "Content validation failed for $url"
            report_entry "$url" "INVALID" "$http_code"
            rm -f "$temp_file" "$temp_converted"
            return 1
        fi

        # Add metadata header
        local fetch_date
        fetch_date=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
        {
            echo "---"
            echo "source_url: $url"
            echo "fetched_at: $fetch_date"
            echo "---"
            echo ""
            cat "$temp_file"
        } > "$cache_file"

        rm -f "$temp_file" "$temp_converted"
        log_info "Cached: $(basename "$cache_file")"
        report_entry "$url" "SUCCESS" "$http_code"

        # Compare with target and detect changes
        if [ -f "$SKILL_DIR/$target" ]; then
            # Extract content for comparison (skip metadata headers)
            local upstream_content
            upstream_content=$(tail -n +6 "$cache_file" | head -100)
            local target_content
            target_content=$(head -100 "$SKILL_DIR/$target")

            # Check for new environment variables
            local new_vars
            new_vars=$(grep -oE '\$APP_[A-Z_]+' "$cache_file" 2>/dev/null | sort -u | \
                comm -23 - <(grep -oE '\$APP_[A-Z_]+' "$SKILL_DIR/$target" 2>/dev/null | sort -u) 2>/dev/null || true)
            if [ -n "$new_vars" ]; then
                for var in $new_vars; do
                    log_change "New environment variable: $var"
                done
            fi

            # Check for version changes
            local upstream_version
            upstream_version=$(grep -oE 'manifestVersion[: ]+[0-9.]+' "$cache_file" 2>/dev/null | head -1 || echo "")
            local target_version
            target_version=$(grep -oE 'manifestVersion[: ]+[0-9.]+' "$SKILL_DIR/$target" 2>/dev/null | head -1 || echo "")
            if [ "$upstream_version" != "$target_version" ] && [ -n "$upstream_version" ]; then
                log_change "manifestVersion changed: $target_version -> $upstream_version"
            fi
        fi

        return 0
    else
        log_error "Failed to fetch: $url (HTTP $http_code)"
        report_entry "$url" "FAILED" "$http_code"
        rm -f "$temp_file" "$temp_converted"
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
    local current_version
    current_version=$(jq -r '.version' "$MANIFEST")
    local major minor patch

    IFS='.' read -r major minor patch <<< "$current_version"
    patch=$((patch + 1))
    local new_version="$major.$minor.$patch"

    if [ "$DRY_RUN" = "true" ]; then
        log_info "Would bump version: $current_version -> $new_version"
    else
        local temp
        temp=$(mktemp)
        jq --arg v "$new_version" '.version = $v' "$MANIFEST" > "$temp"
        mv "$temp" "$MANIFEST"
        log_info "Bumped version: $current_version -> $new_version"
    fi

    echo "$new_version"
}

# Generate sync summary
generate_summary() {
    if [ ! -f "$SYNC_REPORT" ]; then
        return
    fi

    local total=0
    local success=0
    local failed=0
    local skipped=0
    local invalid=0

    while IFS='|' read -r url status code timestamp; do
        [[ "$url" =~ ^# ]] && continue
        ((total++))
        case "$status" in
            SUCCESS) ((success++)) ;;
            FAILED) ((failed++)) ;;
            SKIPPED) ((skipped++)) ;;
            INVALID) ((invalid++)) ;;
        esac
    done < "$SYNC_REPORT"

    echo ""
    log_info "=== Sync Summary ==="
    log_info "Total sources: $total"
    log_info "Successful: $success"
    log_info "Skipped (fresh): $skipped"
    if [ $failed -gt 0 ]; then
        log_warn "Failed: $failed"
    fi
    if [ $invalid -gt 0 ]; then
        log_warn "Invalid content: $invalid"
    fi

    # List failed sources
    if [ $failed -gt 0 ] || [ $invalid -gt 0 ]; then
        echo ""
        log_warn "Failed/Invalid sources:"
        grep -E '\|FAILED\||\|INVALID\|' "$SYNC_REPORT" | while IFS='|' read -r url status code timestamp; do
            log_warn "  - $url ($status, HTTP $code)"
        done
    fi
}

# Main sync logic
main() {
    check_deps
    init_report

    local skill_name
    skill_name=$(jq -r '.name' "$MANIFEST")
    local source_type
    source_type=$(jq -r '.sources' "$MANIFEST")

    log_info "Syncing skill: $skill_name"
    log_info "Skill directory: $SKILL_DIR"
    log_info "Dry run: $DRY_RUN"
    log_info "Force: $FORCE"

    local had_changes=false
    local had_failures=false

    if [ "$source_type" = "registry" ]; then
        # Registry-based sync (claude-code-expert)
        local sync_script
        sync_script=$(jq -r '.sync_script' "$MANIFEST")
        sync_registry "$sync_script"

        # Check if state.json was modified
        if ! git diff --quiet "$SKILL_DIR" 2>/dev/null; then
            had_changes=true
        fi
    else
        # URL-based sources
        local cache_dir="$SKILL_DIR/$(jq -r '.cache_dir // ".cache"' "$MANIFEST")"
        local freshness_days
        freshness_days=$(jq -r '.freshness_days // 14' "$MANIFEST")

        # Process each source
        local sources_json
        sources_json=$(jq -c '.sources[]' "$MANIFEST")

        while IFS= read -r source; do
            local url target source_freshness source_type_val
            url=$(echo "$source" | jq -r '.url')
            target=$(echo "$source" | jq -r '.target')
            source_freshness=$(echo "$source" | jq -r ".freshness_days // $freshness_days")
            source_type_val=$(echo "$source" | jq -r '.type // "raw"')

            # Continue processing even if one source fails
            if ! fetch_url_source "$url" "$target" "$cache_dir" "$source_freshness" "$source_type_val"; then
                had_failures=true
                log_warn "Continuing with remaining sources..."
            fi
        done <<< "$sources_json"

        # Check for changes
        if ! git diff --quiet "$SKILL_DIR" 2>/dev/null; then
            had_changes=true
        fi
    fi

    # Generate summary
    generate_summary

    # Output summary for CI
    if [ "$had_changes" = "true" ]; then
        log_info "Changes detected in $skill_name"
        echo "has_changes=true"
    else
        log_info "No changes detected in $skill_name"
        echo "has_changes=false"
    fi

    if [ "$had_failures" = "true" ]; then
        log_warn "Some sources failed to sync"
        echo "has_failures=true"
    fi

    log_info "Sync complete: $skill_name"
}

main
