# hammer-cli-katello
Next-gen CLI tool for [Katello](http://katello.org) (Katello-specific commands)

hammer-cli development docs for [help](https://github.com/theforeman/hammer-cli/blob/master/doc/developer_docs.md#hammer-development-docs)

## Development setup

The easiest way to set up a hammer development environment is to use the centos7-hammer-devel box in
[forklift](https://github.com/theforeman/forklift).

## Configuration

Configuration files for all hammer plugins are found at
`~/.hammer/cli.modules.d`. The centos7-hammer-devel box configures hammer for
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
