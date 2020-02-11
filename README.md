# Magento baler bundler

![Docker Automated build](https://img.shields.io/docker/automated/mageops/magesuite-baler)
![Docker Build Status](https://img.shields.io/docker/build/mageops/magesuite-baler)
![Docker Pulls](https://img.shields.io/docker/pulls/mageops/magesuite-baler)
![Docker Stars](https://img.shields.io/docker/stars/mageops/magesuite-baler)
![Made by creativestyle](https://img.shields.io/badge/made%20by-creativestyle-%23c12026)

This solution is a sucessor to [MagePack](https://github.com/mageops/docker-magento-advanced-js-bundling) bundler

## Usage
For `$VERSION`, check releases github page
```
docker run --rm -v "$PWD:/workdir:z" -u "$(id -u "$(whoami)")":"$(id -g "$(whoami)")" mageops/magesuite-baler $VERSION
```

## Customization
You can customize behavior with envirionment variables:
- `IGNORE_FILES` - Comma separated list of files patterns that should be excluded from minification (default: `core-bundle.js,*.min.js,requirejs-bundle-config.js`)
- `RESERVED_KEYWORDS` - Comma separated list of keywords that shouldn't be renamed in minification process (default: `\$,jQuery,define,require,exports`)
- `PROCS` - Number of simultaneous minifications processes (default: number of cores)
- `SKIP_DEDUPLICATION` - Skip deduplication of static files (will not create symlinks for duplicated files, but may significally increase time needed for minification)
- `SKIP_MINIFICATION` - Skip minification of static files