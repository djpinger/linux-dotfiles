#!/bin/bash
set -euo pipefail

# Configuration
REMOTE_USER="pinger"
REMOTE_HOST="home"
LOCAL_BACKUP_ROOT="${HOME}/backups/remote-docker-backups"

# Logging with timestamps
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# Dry-run logic
DRY_RUN=false
if [[ "${1:-}" == "--dry-run" ]] || [[ "${1:-}" == "-n" ]]; then
    DRY_RUN=true
    log "!!! DRY RUN MODE ENABLED - No files will be transferred !!!"
fi

# Pre-flight check: SSH connectivity
log "Checking connection to $REMOTE_HOST..."
if ! ssh -q -o BatchMode=yes -o ConnectTimeout=5 "$REMOTE_USER@$REMOTE_HOST" exit; then
    log "Error: Cannot connect to $REMOTE_HOST. Is it up?"
    exit 1
fi

# Create local backup root directory if it doesn't exist
if [[ "$DRY_RUN" == "false" ]]; then
    mkdir -p "$LOCAL_BACKUP_ROOT"
fi

log "Starting backup of remote docker configs and data from $REMOTE_HOST..."

# Function to perform rsync
# Arguments: $1: Remote Source Path, $2: Local Destination Subdir, $3: Optional Exclude Pattern
perform_backup() {
    local src="$1"
    local dst="$LOCAL_BACKUP_ROOT/$2"
    local exclude_pattern="${3:-}"

    log "--- Backing up $src to $dst ---"
    
    if [[ "$DRY_RUN" == "false" ]]; then
        mkdir -p "$dst"
    fi
    
    # Build the rsync command as an array for safe argument handling
    local cmd=(rsync -avz --delete --progress)
    
    if [[ "$DRY_RUN" == "true" ]]; then
        cmd+=(--dry-run)
    fi

    if [[ -n "$exclude_pattern" ]]; then
        cmd+=(--exclude "$exclude_pattern")
    fi

    # Add source and destination
    # The trailing slash on src is important for rsync to copy CONTENTS of dir, not the dir itself
    cmd+=("$REMOTE_USER@$REMOTE_HOST:$src/" "$dst/")
    
    # Execute the command. 
    # Because of 'set -e', the script will exit immediately if this command fails.
    "${cmd[@]}" || { log "Error: Failed to back up $src"; exit 1; }
    
    log "Success: $src backup complete."
}

# 1. Backup Docker configs/data from home dir
perform_backup "/home/${REMOTE_USER}/docker" "docker"

# 2. Backup /srv directory, excluding /srv/media/data (NFS mount)
perform_backup "/srv" "srv" "media/data"

log "Backup process finished."
