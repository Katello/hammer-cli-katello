# hammer-cli-katello ![Travis # Status](https://travis-ci.org/Katello/hammer-cli-katello.svg?branch=master) [![Coverage Status](https://coveralls.io/repos/github/Katello/hammer-cli-katello/badge.svg?branch=master)](https://coveralls.io/github/Katello/hammer-cli-katello?branch=master)

Next-gen CLI tool for [Katello](http://katello.org) (Katello-specific commands)

hammer-cli development docs for [help](https://github.com/theforeman/hammer-cli/blob/master/doc/developer_docs.md#hammer-development-docs)

## Development setup
With this guide, you'll be able to set up hammer-cli-katello, hammer-cli, katello_api, and hammer-cli-foreman for development.

###Requirements for this setup

These are the requirements for this setup. Note that some may not be needed at
all depending on your setup.

* git
* ruby
* rvm
* katello

###Steps

First, cd into the directory where you typically keep your projects and where hammer-cli-katello and its projects will live. Then clone everything.

```bash
git clone https://github.com/Katello/hammer-cli-katello.git
git clone https://github.com/theforeman/hammer-cli.git
git clone https://github.com/theforeman/hammer-cli-foreman.git
git clone https://github.com/theforeman/hammer-cli-foreman-tasks.git
```

Now let's setup our rvm environment files for the project.

```bash
cd hammer-cli-katello
echo "1.9.3" > .ruby-version
echo "hammer" > .ruby-gemset
cd ..; cd -
```

Before we bundle, we need to setup our local Gemfile. Edit `Gemfile.local.rb` in your hammer-cli-katello directory to point to the local projects instead of using the gems. Enter the following:

```ruby
# vim:ft=ruby
gem 'hammer_cli', :path => '../hammer-cli'
gem 'hammer_cli_foreman', :path => '../hammer-cli-foreman'
gem 'hammer_cli_foreman_tasks', :path => '../hammer-cli-foreman-tasks'
```

Now run bundler inside your hammer-cli-katello directory:

```bash
gem install bundler
bundle install
```

Now, let's create the directories we need for configuration.

```bash
mkdir -p ~/.hammer/cli.modules.d
```

Edit `~/.hammer/cli_config.yml` and [enter any hammer-cli config values you
want](https://github.com/theforeman/hammer-cli/blob/master/doc/installation.md#options).

Next edit `~/.hammer/cli.modules.d/foreman.yml` and enter the following:

```yaml
:foreman:
  :enable_module: true
  :host: 'http://localhost:3000/'
  :username: 'admin'
  :password: 'changeme'
```

Edit `~/.hammer/cli.modules.d/katello.yml` and enter in the following:

```yaml
:katello:
  :enable_module: true
```

And then finally test out your installation:

```bash
bundle exec hammer -vh
```

Look for any errors. If you see none, you should be good to go.

## Testing
hammer-cli-foreman stubs the API for functional tests. See
[api_expectations.rb](https://github.com/theforeman/hammer-cli-foreman/blob/master/lib/hammer_cli_foreman/testing/api_expectations.rb). To regenerate the stubbed API, refer to the [test data Readme](https://github.com/katello/hammer-cli-katello/blob/master/test/data/Readme.md).
