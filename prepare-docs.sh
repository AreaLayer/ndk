#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status.

DOCS_DIR="docs"
CORE_DIR="ndk-core"
DEXIE_DIR="ndk-cache-dexie"
NOSTRCACHE_DIR="ndk-cache-nostr"
SQLITE_WASM_DIR="ndk-cache-sqlite-wasm"
MOBILE_DIR="ndk-mobile"
BLOSSOM_DIR="ndk-blossom"
WALLET_DIR="ndk-wallet"
SVELTE_DIR="ndk-svelte"
HOOKS_DIR="ndk-hooks"

# Clean previous copied docs, careful not to remove .vitepress or package.json
echo "Cleaning previous docs..."
rm -rf \
    "$DOCS_DIR/getting-started" \
    "$DOCS_DIR/internals" \
    "$DOCS_DIR/migration" \
    "$DOCS_DIR/tutorial" \
    "$DOCS_DIR/api-examples.md" \
    "$DOCS_DIR/index.md" \
    "$DOCS_DIR/snippets" \
    "$DOCS_DIR/snippets" \
    "$DOCS_DIR/cache" \
    "$DOCS_DIR/mobile" \
    "$DOCS_DIR/wallet" \
    "$DOCS_DIR/wrappers" \
    "$DOCS_DIR/hooks"
# Create target directories
echo "Creating target directories..."
mkdir -p \
    "$DOCS_DIR/snippets" \
    "$DOCS_DIR/cache" \
    "$DOCS_DIR/cache/sqlite-wasm" \
    "$DOCS_DIR/mobile" \
    "$DOCS_DIR/snippets/mobile" \
    "$DOCS_DIR/wallet" \
    "$DOCS_DIR/wallet" \
    "$DOCS_DIR/snippets/wallet" \
    "$DOCS_DIR/wrappers" \
    "$DOCS_DIR/hooks"
# --- Copy functions ---
copy_dir_contents() {
    local src_dir=$1
    local dest_dir=$2
    if [ -d "$src_dir" ]; then
        # Check if source directory is empty or contains files/subdirs
        if [ -n "$(ls -A "$src_dir")" ]; then
             echo "Copying contents from $src_dir to $dest_dir/"
             cp -R "$src_dir"/* "$dest_dir/"
        else
             echo "Source directory $src_dir is empty, skipping copy."
        fi
    else
        echo "Source directory $src_dir does not exist, skipping copy."
    fi
}

copy_file() {
    local src_file=$1
    local dest_dir=$2
    if [ -f "$src_file" ]; then
        echo "Copying file $src_file to $dest_dir/"
        cp "$src_file" "$dest_dir/"
    else
        echo "Source file $src_file does not exist, skipping copy."
    fi
}

# --- Execute copies ---
echo "Copying docs and snippets from packages..."

# Core
copy_dir_contents "$CORE_DIR/docs" "$DOCS_DIR"
copy_dir_contents "$CORE_DIR/snippets" "$DOCS_DIR/snippets"

# Cache Dexie
copy_file "$DEXIE_DIR/docs/cache/dexie.md" "$DOCS_DIR/cache"


# Cache Nostr
copy_file "$NOSTRCACHE_DIR/docs/cache/nostr.md" "$DOCS_DIR/cache"

# Cache SQLite WASM
copy_dir_contents "$SQLITE_WASM_DIR/docs" "$DOCS_DIR/cache/sqlite-wasm"
# Mobile
copy_dir_contents "$MOBILE_DIR/docs" "$DOCS_DIR/mobile"
copy_dir_contents "$MOBILE_DIR/snippets" "$DOCS_DIR/snippets/mobile"

# Blossom
copy_dir_contents "$BLOSSOM_DIR/docs" "$DOCS_DIR"

# Wallet
copy_dir_contents "$WALLET_DIR/docs" "$DOCS_DIR/wallet"
copy_dir_contents "$WALLET_DIR/snippets" "$DOCS_DIR/snippets/wallet"

# Svelte
copy_file "$SVELTE_DIR/docs/wrappers/svelte.md" "$DOCS_DIR/wrappers"

# Hooks
copy_dir_contents "$HOOKS_DIR/docs" "$DOCS_DIR/hooks"

echo "Docs preparation complete."
