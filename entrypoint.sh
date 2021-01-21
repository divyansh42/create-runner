#!/usr/bin/env bash
set -e 
set -o pipefail 

git clone https://github.com/redhat-actions/openshift-self-hosted-runner
cd openshift-self-hosted-runner

##############################################################
## appendParams appends params to the helm command
##############################################################
function appendParams(){
   runner_create_command+=("$1")
}

# delete runner if runner with same name exists
# to avoid action failure
helm uninstall $INPUT_RUNNER_NAME || true

# split repo owner and repository name
IFS='/' read -ra location <<< "$INPUT_RUNNER_LOCATION"

GITHUB_OWNER=${location[0]}
GITHUB_REPO=""
if [[ ${#location[@]} -eq 2 ]]; then
    GITHUB_REPO=${location[1]}
fi

runner_create_command=("helm" "install")

appendParams $INPUT_RUNNER_NAME

namespace_arg=""

if [[ -n $INPUT_NAMESPACE ]]; then
    echo "Setting namespace to '$INPUT_NAMESPACE'"
    namespace_arg="--namespace=$INPUT_NAMESPACE"
else
    echo "No namespace provided"
fi

appendParams "./actions-runner/"
appendParams "--set runnerImage=quay.io/redhat-github-actions/redhat-actions-runner"
appendParams "--set runnerTag=readiness-63e69fd"

appendParams "--set-string githubPat=$INPUT_GITHUB_PAT"
appendParams "--set-string githubOwner=$GITHUB_OWNER"

if [[ -n $GITHUB_REPO ]]; then
    appendParams "--set-string githubRepository=$GITHUB_REPO"
fi  

appendParams "--set-string replicas=$INPUT_REPLICAS"

# appendParams '--set runnerLabels="label1\,label2"'

appendParams $namespace_arg

echo "Running: ${runner_create_command[*]} "
${runner_create_command[*]}

echo "---------------------------------------"
helm get manifest $INPUT_RUNNER_NAME | oc get -f -

runner_created='false'

# wait for all pods to be in running state
oc wait --for=condition=available --timeout=600s deployment/${INPUT_RUNNER_NAME}

if [[ $? -eq 0 ]]; then
    runner_created='true';
    echo "Runner successfully created and ready for use."
else
    echo "Not able to create Runner"
    if [[ $INPUT_FAIL_IF_NOT_CREATED ]]; then
        exit 1
    fi
fi

echo "::set-output name=runner_created::$runner_created"