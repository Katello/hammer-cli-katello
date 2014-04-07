# hammer-cli-katello


Next-gen CLI tool for [Katello](http://katello.org) (Katello-specific commands)

WORK IN PROGRESS

following [hammer-cli-foreman](https://github.com/theforeman/hammer-cli-foreman)'s example

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
git clone https://github.com/Katello/katello_api.git
git clone https://github.com/theforeman/foreman_api.git
```

Now let's setup our rvm environment files for the project.

```bash
cd hammer-cli-katello
echo "1.9.3" > .ruby-version
echo "hammer" > .ruby-gemset
cd ..; cd -
```

Before we bundle, we need to setup our local Gemfile. Edit `Gemfile.local` in your hammer-cli-katello directory to point to the local projects instead of using the gems. Enter the following:

```ruby
# vim:ft=ruby
gem 'hammer_cli', :path => '../hammer-cli'
gem 'hammer_cli_foreman', :path => '../hammer-cli-foreman'
gem 'foreman_api', :path => '../foreman_api'

gem 'katello_api', :path => '../katello_api'
```

Now run bundler inside your hammer-cli-katello directory:

```bash
bundle install
```

Now, let's create the foreman directory and hammer cli config file.

```bash
mkdir ~/.foreman
touch ~/.foreman/cli_config.yml
```

Create `~/.foreman/hammer.modules.d/katello.yml` and enter the following text:

```yaml
:katello
  :enable_module: true
```

And then finally test out your installation:

```bash
bundle exec hammer -vh
```

Look for any errors. If you see none, you should be good to go.

