#!/usr/bin/env bash

set -eu

PTH="$HOME/.vtex/session"
SSN_JSON="session.json"
WRK_JSON="workspace.json"
TKN_JSON="tokens.json"
ACC="$VTEX_ACCOUNT"
KEY="$VTEX_APP_KEY"
TKN="$VTEX_APP_TOKEN"
WRK=${VTEX_WORKSPACE:-master}
BIN=${VTEX_BIN:-vtex-e2e}
export IN_CYPRESS=true

# Show toolbelt version used as GitHub notice
VERSION="$($BIN --version) [from https://github.com/$VTEX_TOOLBELT_GIT/tree/$VTEX_TOOLBELT_BRANCH]"
echo ::notice title=Toolbelt version used::$VERSION

# Function to beauty output
print() {
  if [[ $2 -eq 0 ]]; then
    echo -n "===> $1... "
  else
    echo "$1."
  fi
}

# Function to deal errors
error() {
  print "$1" 0
  exit $2
}

rm -rf $HOME/.vtex && $BIN whoami || error "$BIN not found" 4

echo whoami
whoami

echo pwd
echo $(pwd)

echo ls -a
ls -a

print "Fetching VTEX Token" 0
TKN_CURL=$(curl -s --location \
  --request POST "https://vtexid.vtex.com.br/api/vtexid/apptoken/login?an=$ACC" \
  --header 'Content-Type: application/json' \
  --data-raw '{"appkey": "'$KEY'", "apptoken": "'$TKN'" }') || error "failed to fetch the token" 5
  print "token fetched" 1

print "Creating $SSN_JSON" 0
  mkdir -p $PTH
  RPS=$(jq ".account = \"$ACC\"" <<<"$TKN_CURL")
  jq ".login = \"$KEY\"" <<<"$RPS" >"$PTH/$SSN_JSON"
  RPS_TKN=$(printf '%s\n' "$RPS" | jq -r .RPS_TKN)
  [[ -f $PTH/$SSN_JSON ]] || error "failed to create $SSN_JSON" 6
  print "$SSN_JSON created" 1

print "Creating $WRK_JSON" 0
  echo '{ "currentWorkspace": "'$WRK'",
          "lastWorkspace": null }' >"$PTH/$WRK_JSON"
  [[ -f $PTH/$WRK_JSON ]] || error "failed to create $WRK_JSON" 7
  print "$WRK_JSON created" 1

print "Creating $TKN_JSON" 0
echo '{ "'$ACC'": "'$RPS_TKN'" }' >"$PTH/$TKN_JSON"
[[ -f $PTH/$TKN_JSON ]] || error "failed to create $TKN_JSON" 8
  print "$TKN_JSON created" 1

$BIN whoami || error "Something very odd happened, sorry about that" 9
