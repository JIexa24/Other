#!/bin/bash
__VENV_MAX_TREE_LEVELS_UP=5

function venv_order_priority() {
  echo $1 $1/.venv $1.venv
}

function venv_find_up() {
  local venv_root=${1:-"."}
  local venv_found=""

  for ((i = 0; i < ${__VENV_MAX_TREE_LEVELS_UP}; i++)); do
    local venv_real=$(cd ${venv_root} && pwd -P)
    local venv_name=$(basename ${venv_real})

    for candidate in $(venv_order_priority ${venv_real}); do
      if [ -f "${candidate}/bin/activate" ]; then
        echo ${candidate}
        return 0
      fi
    done

    if [ "${venv_real}" = "/" ]; then
      break
    fi
    venv_root=${venv_root}/".."
  done
  echo ""
  return 1
}

function venv_print() {
  if [ -n "${VIRTUAL_ENV}" -a "$(type -t deactivate)" = 'function' ]; then
    echo ${VIRTUAL_ENV}
  fi
}

function venv_auto() {
  venv_new="$(venv_find_up)"
  venv_old="$(venv_print)"
  bash_cmd=$(basename $(expr "$BASH_COMMAND" : "\([^ ]*\)"))

  if [ -n "$venv_old" -a \( "$bash_cmd" == "mc" -o "$bash_cmd" == "bash" -o "$bash_cmd" == "sh" \) ]; then
    deactivate
  elif [ -z "$venv_new" -a -n "$venv_old" ]; then
    deactivate
  elif [ -n "$venv_new" -a "$venv_new" != "$venv_old" ]; then
    source "$venv_new"/bin/activate
  fi
}

trap venv_auto DEBUG
