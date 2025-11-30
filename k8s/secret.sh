#!/bin/bash

set -o allexport
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../app/.env"
set +o allexport


kubectl create secret generic k8s-sandbox-secret \
    --from-literal=SECRET_VALUE=${SECRET_VALUE}