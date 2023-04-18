# Toolbelt action

This GitHub action deploys the [VTEX Toolbelt](https://github.com/vtex/toolbelt) and can do log in using KEY/TOKEN. It can be useful to automate you CI/CD pipelines or just to schedules day-to-day tasks like cleaning dirty workspaces.

## Features

* Deploy [VTEX Toolbelt](https://github.com/vtex/toolbelt) (you can customize the repository/branch)
* Change the tool name, i.e. instead of `vtex` it can go by `vtex-e2e`
* Login using `app key` and `app token`
* Cache resources to do the next deploy faster
* Check every step and stop if anything goes wrong

## Usage

### Most basic one, just deploy the VTEX Toolbelt

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
    timeout-minutes: 2
    steps:
      - name: Deploy toolbelt
        uses: vtex/action-toolbelt@v8
```          

### More advanced, deploy from specific branch and do log in

If you want to log in, please, add two secrets on your repository secrets:

1. One for the app key, in our example it is `VTEX_TOOLBELT_KEY`
2. Other for the token, in our example it is `VTEX_TOOLBELT_TOKEN`

Next you need to set up your workflow like the example bellow, and that's it.

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
    timeout-minutes: 2
    steps:
      - name: Deploy toolbelt and login
        uses: vtex/action-toolbelt@v8
        with:
          account: YOUR_ACCOUNT
          appKey: ${{ secrets.VTEX_TOOLBELT_KEY }}
          appToken: ${{ secrets.VTEX_TOOLBELT_TOKEN }}
          authenticate: true        # defaults to true, but it'll be false if
                                    # any of account, appKey or appToken is missing
          workspace: master         # defaults to master
          bin: vtex                 # defaults to vtex
          version: 3.0.0-beta-ci.3  # defaults to 3.0.0-beta-ci.3

      - name: Do something after the login
        # The call name bellow must be the same given as *with: bin*
        run: vtex workspace ls

      - name: Logout
        # The call name bellow must be the same given as *with: bin*
        run: vtex logout
```

## Output

The output of this workflow will be something like that:

```text
::notice title=Toolbelt version used::vtex/3.0.0 linux-x64 node-v16.13.0 [from https://github.com/vtex/toolbelt/tree/]
===> Fetching VTEX token... done.
===> Creating session.json... done.
===> Creating workspace.json... done.
===> Checking authentication... done.
14:01:15.234 - info: Logged into account as vtexkey-account-ABC at production workspace master
```

## Credits
This action was made based on this [issue discussion](https://github.com/vtex/toolbelt/issues/1162) inspiration and I'll give my thanks to:
* [rod-dot-codes](https://github.com/rod-dot-codes) for bridging the question and do a Python version of the script
* [cantoniazzi](https://github.com/cantoniazzi) for giving the direction to do it using only [cURL](https://curl.se/)
* [achirus-code](https://github.com/achirus-code) for making a version in [Bash](https://www.gnu.org/software/bash/) that inspired this action

**Together we can do more!**
