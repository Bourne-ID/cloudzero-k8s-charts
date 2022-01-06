#!/usr/bin/env bash
set -euo pipefail

GIT_REPO_ROOT=$(git rev-parse --show-toplevel)
BUILD_DIR="${GIT_REPO_ROOT}/build"
TOOLS_DIR="${BUILD_DIR}/tools"
STABLE="${GIT_REPO_ROOT}/stable"
PACKAGE_DIR="${GIT_REPO_ROOT}/build"
export PATH="${TOOLS_DIR}:${PATH}"

if [[ -v GITHUB_ACTIONS && ${GITHUB_ACTIONS} = "true" ]]; then
    REPOSITORY="https://eks-bot:${GITHUB_TOKEN}@github.com/cloudzero/cloudzero-k8s-charts.git"
    git config user.email eks-bot@users.noreply.github.com
    git config user.name eks-bot
    git remote set-url origin ${REPOSITORY}
    git checkout gh-pages
    mv -f $PACKAGE_DIR/stable/*.tgz .
    helm repo index . --url https://cloudzero.github.io/cloudzero-k8s-charts/
    git add .
    git commit -m "Publish stable charts ${GITHUB_RUN_NUMBER}"
    git push origin gh-pages
    echo "✅ Published charts"
else
    echo "not running in GitHub actions Skip charts publish"
    # Need to exit 0 here since circle ci runs this everytime
    exit 0
fi
 