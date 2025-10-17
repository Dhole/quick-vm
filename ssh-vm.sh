#!/bin/sh

set -ex

ssh -i id_ed25519 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 2222 user@localhost $@
