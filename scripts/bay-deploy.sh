#!/usr/bin/env bash

BAY_ENDPOINT_DEPLOY=http://rest2tasks-lagoon-master.lagoon.vicsdp.amazee.io/deploy
BAY_BRANCH=${BAY_BRANCH:-$1}

bay_project=$(awk '$1=="project:"{print $2}' .lagoon.yml)

if [ -z $BAY_BRANCH ]; then
    BAY_BRANCH=$(git symbolic-ref --short -q HEAD)
fi

branch_sha=$(git ls-remote origin | grep refs/heads/${BAY_BRANCH} | cut -f 1)
[ -z $branch_sha ] && echo "ERROR: Fetching of the remote failed. Please ensure you are connected to the internet and have sufficient permissions to access the repository." && exit 1

echo "Project:  $bay_project"
echo "Branch:   $BAY_BRANCH"
echo "SHA:      $branch_sha"

curl -X POST -d projectName=${bay_project} -d sha=${branch_sha} -d branchName=${BAY_BRANCH} ${BAY_ENDPOINT_DEPLOY}
