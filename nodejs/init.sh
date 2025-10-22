#!/bin/bash

init_node() {

fnm install 22
# Verify the Node.js version:
node -v # Should print "v22.20.0".
# Download and install pnpm:
corepack enable pnpm
# Verify pnpm version:
pnpm -v
}