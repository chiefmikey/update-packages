#!/bin/bash

git config --global user.name "Mikl Wolfe"
git config --global user.email "wolfemikl@gmail.com"
git checkout -b update-packages
npm i

STATUS=0
LOG=""

function log () {
  LINKED_PACKAGE="[${1}]($(npm view "${2}" homepage))"
  LOG="${LOG}$'\n'${LINKED_PACKAGE}" || LOG="${LINKED_PACKAGE}"
}

function handle_git () {
  git add package.json
  git commit -am 'chore(dependencies): bump'
  git push -f origin update-packages
  PR_BODY="$(npm view "${package}")"
  PR_PACKAGE=""
  if [ "${PR_PER}" = false ]; then
   PR_BODY="${LOG}"
  else
    PR_PACKAGE="${package} (${v1} -> ${v2*})"
  fi
  [ -n "${PR_TITLE}" ] && PR_TITLE="${PR_TITLE} "
  [ -n "${PR_LABELS}" ] && PR_LABELS="- l ${PR_LABELS}"
  gh pr create "${PR_LABELS}" -t "${PR_TITLE}${PR_PACKAGE}" -b "${PR_BODY}"
}

for dependency in $(jq -r '.dependencies | to_entries[] | "\(.key)@\(.value)"' package.json); do
  package="${dependency%@*}"
  v1="${dependency#*@}"
  v1="${dependency#?}"
  v2="$(npm view "${package}" version)"
  OUTPUT="${package} (${v1} -> ${v2})"

  if [ "${v1}" != "${v2}" ]; then
    [  "${PACKAGE_LOCK}" = false ] && PACKAGE_LOCK=--no-package-lock
    npm i -s "${PACKAGE_LOCK}" "${package}"
    if [ "${PR_PER}" = true ]; then
      handle_git
    fi
    log "${OUTPUT}" "${package}"
    echo "${OUTPUT}"
    STATUS=1
  fi
done

if [ "${PR_PER}" = false ] && [ "${STATUS}" = 1 ]; then
  handle_git
fi

echo "::set-output name=LOG::${LOG}"
echo "::set-output name=STATUS::${STATUS}"
