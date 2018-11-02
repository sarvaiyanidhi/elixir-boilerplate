#!/usr/bin/env sh

error_status=0

RED='\033[0;31m'
RED_BOLD='\033[1;31m'
GREEN='\033[0;32m'
GREEN_BOLD='\033[1;32m'
YELLOW='\033[0;33m'
NO_COLOR='\033[0m'

header() {
  echo "\n\n${YELLOW}▶ $1${NO_COLOR}"
}

run() {
  eval "${@}"
  last_exit_status=${?}

  if [ ${last_exit_status} -ne 0 ]; then
    echo "\n${RED}↳ Something went wrong. Program exited with ${last_exit_status} ✘${NO_COLOR}"
    error_status=${last_exit_status}
  else
    echo "${GREEN}↳ Passed ✔${NO_COLOR}"
  fi
}

header "Code format and linting…"
run make lint

header "Run tests…"
run make test

header "Code coverage…"
run make coverage

header "Dialyzer…"
run make dialyzer

header "Web app JavaScript lint…"
run npm --prefix assets run lint-scripts

header "Web app styles lint…"
run npm --prefix assets run lint-styles

header "Web app code auto-formatting…"
run npm --prefix assets run prettier-check

header "Execute data seed…"
run mix run priv/repo/seeds.exs

if [ ${error_status} -ne 0 ]; then
  echo "\n\n${YELLOW}▶▶ One of the checks ${RED_BOLD}failed${YELLOW}. Please fix it before committing.${NO_COLOR}"
else
  echo "\n\n${YELLOW}▶▶ All checks ${GREEN_BOLD}passed${YELLOW}!${NO_COLOR}"
fi

exit $error_status
