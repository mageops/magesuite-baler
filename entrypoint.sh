#!/usr/bin/env bash
set -e

if [ -n "$IGNORE_FILES" ];then
    IFS=',' read -r -a IGNORE_FILES <<< "$IGNORE_FILES"
else
    IGNORE_FILES=( 'core-bundle.js' '*.min.js' 'requirejs-bundle-config.js' )
fi

if [ -n "$RESERVED_KEYWORDS" ];then
    IFS=',' read -r -a RESERVED_KEYWORDS <<< "$RESERVED_KEYWORDS"
else
    RESERVED_KEYWORDS=( '$' 'jQuery' 'define' 'require' 'exports' )
fi

[ -z "$PROCS" ] && PROCS="$( nproc )"

ROOT_DIR="/workdir"
THEME_DIR="$ROOT_DIR/pub/static/frontend"

fatal() {
    echo "$@" &>2
    exit 1
}

function join_by {
    local IFS="$1"
    shift
    echo "$*"
}

deduplicate() {
    rdfind -makesymlinks true -makeresultsfile false "$ROOT_DIR/pub/static/frontend"
    symlinks -rc "$ROOT_DIR/pub/static/frontend"
}

bundle() {
    (
        cd "$ROOT_DIR"
        baler build
    )
}

minify() {
    local find_ignore_args=()
    local reserved_keywords=""
    local file

    for file in "${IGNORE_FILES[@]}";do
        find_ignore_args+=( -not -name "$file" )
    done
    reserved_keywords=$(join_by "," "${RESERVED_KEYWORDS[@]}")
    find "$THEME_DIR" \
        -type f \
        \( -name '*.js' "${find_ignore_args[@]}" \) \
        -print0 | xargs -0 -P "$PROCS" -I '{}' \
        terser '{}' -c -m "reserved=[$reserved_keywords]" -o '{}'
}

[ ! -d "$ROOT_DIR" ] && fatal "You need to mount $ROOT_DIR as volume to your magento root directory"
[ ! -d "$THEME_DIR" ] && fatal "$THEME_DIR not exists, you need to generate themes first"

bundle
if [ -z "$SKIP_DEDUPLICATION" ];then
    # deduplication step helps to keep minification times reasonable
    deduplicate
fi
if [ -z "$SKIP_MINIFICATION" ];then
    minify
fi