# Toolbelt action

This GitHub action deploys the VTEX Toolbelt Cli and do a login on the account requested using KEY/TOKEN. This can be very useful when you want to automate you CI/CD pipelines by cleaning dirty workspaces, for example.

## Features

* Deploy the VTEX Toolbelt Cli from the repository/branch you pass
* You can choose the tool call name, i.e. instead of `vtex` it can go by `vtex-e2e`
* Do a login using app key and app token
* Cache resources to do the next deploy faster* 

## Usage

To use it, you need to create two secrets on the repository:
* one for the app key, in our example we called ib `VTEX_TOOLBELT_KEY`
* other for the token, in our example it is `VTEX_TOOLBELT_TOKEN`.

Next you need to set your workflow like the example bellow, and that's it:

```yml
# someworkflow.yml
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

# Credits
This action was made based on this [issue discussion](https://github.com/vtex/toolbelt/issues/1162) inspiration and I'll give my thanks to:
* [rod-dot-codes](https://github.com/rod-dot-codes) for bridging the question and do a Python version of the script;
* [cantoniazzi](https://github.com/cantoniazzi) for giving the direction to do it using only [cURL](https://curl.se/);
* [achirus-code(https://github.com/achirus-code) for making a version in [Bash](https://www.gnu.org/software/bash/) that inspired this action.

Thank you all!