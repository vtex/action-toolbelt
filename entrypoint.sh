#!/usr/bin/env bash

set -e

# Function to beauty output
print() {
  [[ $1 != 'ok' ]] && echo -n "===> $1... " || echo "done."
}

# Function to deal errors
error() {
  echo -e "$1!" && exit $2
}

# Variables
[[ -z $VTEX_ACCOUNT ]] && CHECK=failed
[[ -z $VTEX_APP_KEY ]] && CHECK=failed
[[ -z $VTEX_APP_TOKEN ]] && CHECK=failed
PTH="$HOME/.vtex/session"
SSN_JSON="session.json"
WRK_JSON="workspace.json"
ACC="$VTEX_ACCOUNT"
KEY="$VTEX_APP_KEY"
TKN="$VTEX_APP_TOKEN"
WRK=${VTEX_WORKSPACE:-master}
BIN=${VTEX_BIN:-vtex}
AUT=${VTEX_AUTHENTICATE:-true}
[[ -n $CHECK ]] && AUT='false'

# Show toolbelt version used as GitHub notice
VERSION="$($BIN --version)"
echo ::notice title=Toolbelt version used::$VERSION

# If VTEX_AUTHENTICATE is true
if [[ $AUT == 'true' ]]; then

  # Clean previous login if any
  rm -rf $HOME/.vtex

  # Check if the toolbelt is installed and working
  $BIN whoami &> /dev/null || error "$BIN not installed" 4

  # Get token
  print "Fetching VTEX token"
  CURL=$(curl --silent --location --fail \
    --request POST "https://vtexid.vtex.com.br/api/vtexid/apptoken/login?an=$ACC" \
    --header 'Content-Type: application/json' \
    --data-raw '{"appkey": "'$KEY'", "apptoken": "'$TKN'" }') || error "failed, check your key and token" 5
    CHECK=$(echo $CURL | grep -i success)
    [[ -n $CHECK ]] && print ok || error "failed to check curl response" 6

  # Make session json
  print "Creating $SSN_JSON"
    mkdir -p $PTH
    echo $(jq --arg acc $ACC --arg key $KEY '. + {account: $acc, login: $key}' <<< $CURL) > "$PTH/$SSN_JSON"
    CHECK=$(jq '. | length' < "$PTH/$SSN_JSON")
    [[ $CHECK -ge 5 ]] && print ok || error failed 7

  # Make workspace json
  print "Creating $WRK_JSON"
    echo $(jq --null-input --arg wrk $WRK '{currentWorkspace: $wrk, lastWorkspace: null}') > "$PTH/$WRK_JSON"
    CHECK=$(jq '. | length' < "$PTH/$WRK_JSON")
    [[ $CHECK -ge 2 ]] && print ok || error failed 8

  # Test to test authentication
  print "Checking authentication"
    CHECK=$($BIN whoami | grep $ACC) || error "Something very odd happened, sorry about that" 9
    [[ -n $CHECK ]] && print ok || error "failed login" 10
    echo $CHECK
else
    echo "===> Authentication process skipped."
fi
