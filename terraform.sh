#!/usr/bin/env bash

set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT

usage() {
  cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") TF_COMMAND ENV [TF_ARGS]

This is a wrapper around Terraform.
EOF
  exit
}

cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
  # cleanup command here
}

msg() {
  echo >&2 -e "${1-}"
}

die() {
  local msg=$1
  local code=${2-1} # default exit status 1
  msg "$msg"
  exit "$code"
}

parse_params() {
  [[ ${#@} -eq 0 ]] && die "Missing required commands: TF_COMMAND"
  action=$1
  shift 1

  [[ ${#@} -eq 0 ]] && die "Missing required commands: ENV"
  env=$1
  shift 1

  args=("$@")
}

load_awscli_profile() {
  local backend_ini="./env/$env/backend.ini"

  if [[ "${CI-}" != true && -f "$backend_ini" ]]; then
    source $backend_ini
    export AWS_PROFILE=${aws_profile}
  else
    msg "No AWS CLI profile loaded"
  fi
}

tf_reconfigure() {
  local backend_config=$1

  terraform init -reconfigure -backend-config="$backend_config"
}

proxy_tf() {
  local backend_config="./env/$env/backend.tfvars"
  local var_file="./env/$env/terraform.tfvars"

  case $action in
    init)
      terraform $action -backend-config="$backend_config" ${args-}
      ;;
    output | state | taint)
      tf_reconfigure $backend_config
      terraform $action ${args-}
      ;;
    plan | apply | refresh | import | output | destroy)
      tf_reconfigure $backend_config
      terraform $action -var-file="$var_file" ${args-}
      ;;
    lock)
      terraform providers lock \
        -platform=windows_amd64 \
        -platform=darwin_amd64 \
        -platform=darwin_arm64 \
        -platform=linux_amd64
      ;;
    *)
      die "Action not allowed"
      ;;
  esac
}

parse_params "$@"
load_awscli_profile
proxy_tf
