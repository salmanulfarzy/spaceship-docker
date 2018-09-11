#!/usr/bin/env zsh

set -eu

default_version='5.2'

setopt extended_glob glob_subst numeric_glob_sort
setopt warn_create_global warn_nested_var 2> /dev/null

typeset -aU versions
versions=( $PWd/base-*/Dockerfile(N.on:h:t:s/base-//) )
typeset -r versions

typeset -aU frameworks
frameworks=( $PWD/*/Dockerfile(N.on:h:t) )
for i in {$#frameworks..1}; do
  # Remove all base entries
  [[ "${frameworks[$i]}" == base-* ]] && frameworks[$i]=()
done
typeset -r frameworks


resolve_framework() {
  local f=$1 found
  found=${frameworks[(In:-1:)$f*]}
  if (( found <= $#frameworks )); then
    echo "${frameworks[$found]}"
  fi
}

resolve_version() {
  local v=$1 found
  found=${versions[(In:-1:)$v*]}
  if (( found <= $#versions )); then
    echo "${versions[$found]}"
  fi
}

cmd() {
  if (( dry_run )); then
    echo "${(@q)*}" 1>&2
  else
    "${(@)*}"
  fi
}

build_and_run() {
  local version="$1"
  local framework="$2"
  local name="${version}-${framework}"

  print -P "%F{green}Preparing containers...%f"

  echo -n "spaceship:base-${version}: "
  cmd docker build \
    --quiet \
    --tag "spaceship:base-${version}" \
    --file "$PWD/base-${version}/Dockerfile" \
    .

  echo -n "spaceship:${version}-${framework}: "
  cmd docker build \
    --quiet \
    --build-arg="base=base-${version}" \
    --tag "spaceship:${version}-${framework}" \
    --file "$PWd/${framework}/Dockerfile" \
    .

  print -P "%F{green}Starting ${name} container...%f"
  cmd docker run \
    --rm \
    --interactive \
    --tty \
    --hostname="${name//./_}" \
    --env="TERM=${term}" \
    "spaceship:${version}-${framework}"
}

# Parse flags and such.
asked_for_version=$default_version
asked_for_framework=
dry_run=0
while (( $# > 0 )); do
  case "$1" in
    -f | --frameworks )
      print -l "${(@)frameworks}"
      exit
      ;;
    -v | --versions )
      print -l "${(@)versions}"
      exit
      ;;
    -z | --zsh )
      shift
      asked_for_version=$1
      ;;
    -n | --dry-run ) dry_run=1 ;;
    -h | --help )
      show_help
      exit
      ;;;
    -* )
      err "Unknown option ${1}"
      show_help
      exit 1
      ;;
    * )
      if [[ -z "$asked_for_framework" ]]; then
        asked_for_framework=$1
      else
        err "You can only specify one framework at a time; you already specified '${asked_for_framework}'"
      fi
      ;;
  esac
  shift
done

typeset -r asked_for_version asked_for_framework

typeset -r use_version="$(resolve_version "${asked_for_version}")"
if [[ -z "$use_version" ]]; then
  err "No such ZSH version '${asked_for_version}'"
fi

typeset -r use_framework="$(resolve_framework "${asked_for_framework}")"
if [[ -z "$use_framework" ]]; then
  err "No such framework '${asked_for_framework}'"
fi

build_and_run "$use_version" "$use_framework"

# EOF
