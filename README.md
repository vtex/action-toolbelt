# Toolbelt action

This GitHub action deploys the tool [VTEX Toolbelt](https://github.com/vtex/toolbelt) and do a login on the account requested using KEY/TOKEN.
It is useful when you want to automate you CI/CD pipelines --- by cleaning dirty workspaces, for example.

## Features

* Deploy [VTEX Toolbelt](https://github.com/vtex/toolbelt) from the customizable repository/branch
* Change the tool call name, i.e. instead of `vtex` it can go by `vtex-e2e`
* Login using `app key` and `app token`
* Cache resources to do the next deploy faster

## Usage

First you need need to create two secrets on your repository

1. One for the app key, in our example we called ib `VTEX_TOOLBELT_KEY`
2. Other for the token, in our example it is `VTEX_TOOLBELT_TOKEN`

Next you need to set up your workflow like the example bellow, and that's it:

```yml
# toolbelt-workflow.yml
name: [QE] Deploy Toolbelt

on:
  push:
    branches:
      - master
      - main
  workflow_dispatch:

jobs:
  deploy:
    name: Toolbelt deploy and login
    runs-on: ubuntu-latest
    timeout-minutes: 5
    steps:
      - name: Deploy toolbelt and login
        uses: vtex/action-toolbelt@v1
        with:
          account: YOUR_ACCOUNT
          appKey: ${{ secrets.VTEX_TOOLBELT_KEY }}
          appToken: ${{ secrets.VTEX_TOOLBELT_TOKEN }}
          workspace: master       # defaults to master if omitted
          bin: vtex-e2e           # defaults to vtex-e2e if omitted 
          git: vtex/toolbelt      # defaults to vtex/toolbelt if omitted
          branch: qe/cypress      # defaults to qe/cypress if omitted

      - name: Do something after the login
        run: vtex-e2e workspace ls
        # The call name bellow must be the same given as *with: bin*

      - name: Logout'
        run: vtex-e2e logout
        # Not needed, the .vtex folder isn't saved on cache
```

## Output

The output of this workflow will be something like that:

```text
Notice: vtex/3.0.0 linux-x64 node-v16.16.0 [from https://github.com/vtex/toolbelt/tree/qe/cypress]
01:54:21.493 - info: Welcome to VTEX IO  
01:54:21.494 - info: Log in by running vtex login <account-name>  
===> Fetching VTEX Token... token fetched.
===> Creating session.json... session.json created.
===> Creating workspace.json... workspace.json created.
===> Creating tokens.json... tokens.json created.
01:54:23.891 - info: Logged into productusqa as *** at production workspace master  
```

## Credits
This action was made based on this [issue discussion](https://github.com/vtex/toolbelt/issues/1162) inspiration and I'll give my thanks to:
* [rod-dot-codes](https://github.com/rod-dot-codes) for bridging the question and do a Python version of the script
* [cantoniazzi](https://github.com/cantoniazzi) for giving the direction to do it using only [cURL](https://curl.se/)
* [achirus-code](https://github.com/achirus-code) for making a version in [Bash](https://www.gnu.org/software/bash/) that inspired this action
@thyarles
*Together we can do more!*
