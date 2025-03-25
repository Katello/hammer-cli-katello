# hammer-cli-katello
Next-gen CLI tool for [Katello](http://katello.org) (Katello-specific commands)

hammer-cli development docs for [help](https://github.com/theforeman/hammer-cli/blob/master/doc/developer_docs.md#hammer-development-docs)

## Development setup

The easiest way to set up a hammer development environment is to use the `hammer-devel-container.sh` script.
* Clone this repo.
* Run the following commands
```bash
$ cd hammer-cli-katello
$ hammer-devel-container.sh
```
This should start a container that points to your localhost foreman server

Alternately you can use the centos7-hammer-devel box in
[forklift](https://github.com/theforeman/forklift).

### From the source

If you don't want to use any of the automated setups above, you can always set hammer up to be used with Katello
manually. The easiest way is to follow these steps:

1. Clone the mandatory repos:

This is the core, but without any auth capabilities or commands.
```bash
git clone git@github.com:theforeman/hammer-cli.git
```
This is a plugin with Foreman commands and auth capabilities.
```bash
git clone git@github.com:theforeman/hammer-cli-foreman.git
```
This is a plugin with Katello commands.
```bash
git clone git@github.com:Katello/hammer-cli-katello.git
```
_Note: you might want to add more plugins (e.g. foreman-virt-who-configure), the steps are the same._

2. Create a local Gemfile to point to your plugins:
```bash
cd hammer-cli && touch Gemfile.local
```
```bash
cat > Gemfile.local <<'PLUGINS'
path '../' do
  gem "hammer_cli_foreman"
  gem "hammer_cli_katello"
end
PLUGINS
```
```bash
bundle install
```
3. Configure hammer and plugins:

Adjust `cli_config.yml` per your needs.
```bash
mkdir -p ~/.hammer && cp hammer-cli/config/cli_config.template.yml ~/.hammer/cli_config.yml
```
```bash
mkdir -p ~/.hammer/cli.modules.d && cp hammer-cli-foreman/config/foreman.yml ~/.hammer/cli.modules.d/foreman.yml
```
```bash
cp hammer-cli-katello/config/katello.yml ~/.hammer/cli.modules.d/katello.yml
```
If you don't want to be prompted each time, you'd rather put values at least for `:host:`, `:username:` and `:password:`.
```bash
cat > ~/.hammer/cli.modules.d/foreman.yml <<'CONFIG'
:foreman:
  :enable_module: true
  :host: https://foreman.example.com:443
  :username: 'admin'
  :password: 'changeme'
CONFIG
```
4. Try running a command to see if hammer works:
```bash
cd hammer-cli && bundle exec ./bin/hammer ping
```
5. (Optional) Set up an alias for convenience:
```bash
# Add to your ~/.bashrc or ~/.bash_profile
alias hammer='BUNDLE_GEMFILE=/home/vagrant/hammer-cli/Gemfile bundle exec hammer'
```
_Note: You might encounter an SSL issue on first run and if so, there are two ways to fix that. There should also be a help message from hammer itself._
1. Fetch the CA from the server:
```bash
hammer --fetch-ca-cert https://foreman.example.com
```
2. Or disable SSL verification either in `~/.hammer/cli_config.yml` or run a hammer command with `--verify-ssl` false option.

## Configuration

Configuration files for all hammer plugins are found at
`~/.hammer/cli.modules.d`. The centos9-hammer-devel box configures hammer for
you, but you may change the configuration files directly as well.
The `hammer-cli-katello` configuration is located at
`~/.hammer/cli.modules.d/katello.yml`.

The overall hammer config is found at `~/.hammer/cli_config.yml`.
[The hammer-cli docs](https://github.com/theforeman/hammer-cli/blob/master/doc/installation.md#options)
provide more information on possible configuration values. One useful
configuration option is the Katello server to point to; that is found in
`~/.hammer/cli.modules.d/foreman.yml`.

## Running Hammer

Hammer is run as an executable from the root of the hammer-cli-katello
repository.

```bash
bundle exec hammer -vh
```

Look for any errors. If you see none, you should be good to go.

## Testing

To run the tests with rubocop:

```sh
rake
```

To run the tests only:

```sh
rake test
```

To run a specific test:

```sh
rake test TEST="test/functional/content_views/show_test.rb"
```

There are both unit tests and functional tests. Unit tests are used for
supporting code, such as `lib/hammer_cli_katello/id_resolver.rb`. Functional
tests are used for testing the input/output interaction of hammer with the Katello API.

hammer-cli-foreman stubs the API for functional tests. See
[api_expectations.rb](https://github.com/theforeman/hammer-cli-foreman/blob/master/lib/hammer_cli_foreman/testing/api_expectations.rb). To regenerate the stubbed API, refer to the [test data Readme](https://github.com/katello/hammer-cli-katello/blob/master/test/data/Readme.md).

Each subcommand action is tested in its own test file. An example is `hammer
content-view update`; it is stored in
`test/functional/content_view/update_test.rb`.

For most hammer sub-commands, there are common API calls that are used to
resolve database object IDs. These are usually accompanied with helpers to test
the common API calls. An example is the
[`OrganizationHelpers`](https://github.com/Katello/hammer-cli-katello/blob/master/test/functional/organization/organization_helpers.rb).

A typical functional test takes this form:

```rb
it 'allows minimal options' do
  api_expects(:content_views, :update) do |p| # expect an API call to ContentViews#Update
    p['id'] == 2 # expect the params to include {'id' => 2}
  end

  run_cmd(%w(content-view update --id 2)) # Run the hammer command to test
end
```
