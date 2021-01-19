#!/usr/bin/env bash
set -e 
set -o pipefail 

git clone https://github.com/redhat-actions/openshift-self-hosted-runner
cd openshift-self-hosted-runner
##############################################################
## appendParams appends params to the helm command
##############################################################
function appendParams(){
   runner_install_command+=("$1")
}

runner_install_command=("helm" "install" "runner")

namespace_arg=""

if [[ -n $INPUT_NAMESPACE ]]; then
    echo "Setting service namespace to '$INPUT_NAMESPACE'"
    namespace_arg="--namespace=$INPUT_NAMESPACE"
else
    echo "No namespace provided"
fi

appendParams "./runner-charts/deployment"
appendParams "--set-string githubOwner=$INPUT_OWNER"
if [[ -n $INPUT_REPOSITORY ]]; then
    appendParams "--set-string githubRepository=$INPUT_REPOSITORY"
fi    

appendParams $namespace_arg

helm install runner-pat ./runner-charts/pat-secret \
--set-string githubPat=$INPUT_PAT

echo "Running: ${runner_install_command[*]} "
${runner_install_command[*]}