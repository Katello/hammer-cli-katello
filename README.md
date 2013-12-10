# hammer-cli-katello


Next-gen CLI tool for [Katello](http://katello.org) (Katello-specific commands)

WORK IN PROGRESS

following [hammer-cli-foreman](https://github.com/theforeman/hammer-cli-foreman)'s example

hammer-cli development docs for [help](https://github.com/theforeman/hammer-cli/blob/master/doc/developer_docs.md#hammer-development-docs)

## development setup

create `~/.foreman/cli_config.yml` and put this in it:

```yaml
:modules:
  - hammer_cli_foreman
  - hammer_cli_katello

:foreman:
  :host: 'http://localhost:3000/'
  :username: 'admin'
  :password: 'changeme'

# :watch_plain: true disables color output of logger.watch in Clamp commands
:watch_plain: false

#:log_dir: '/var/log/foreman'
:log_dir: '~/.foreman/log'
:log_level: 'debug'
```

if you'd like to run any gems from source or include others for personal development purposes, create a file called `Gemfile.local` in the root directory of this repo and add as many `gem 'katello_api', :path => '../katello_api'` statements as you'd like.
