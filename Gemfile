source "https://rubygems.org"

gemspec

# for generating i18n files, gettext > 3.0 dropped ruby 1.8 support
gem 'gettext', '>= 3.1.3', '< 4.0.0'

group :test do
  gem 'ci_reporter', '>= 1.6.3', "< 2.0.0", :require => false
  gem 'coveralls', '0.8.23', require: false
  gem 'minitest', '4.7.4'
  gem 'minitest-spec-context'
  gem 'mocha'
  gem 'rake', '~> 10.1.0'
  gem 'rubocop', '~> 1.28.0'
  gem 'rubocop-checkstyle_formatter'
  gem 'thor'
end

# load local gemfile
['Gemfile.local.rb', 'Gemfile.local'].map do |file_name|
  local_gemfile = File.join(File.dirname(__FILE__), file_name)
  self.instance_eval(Bundler.read_file(local_gemfile)) if File.exist?(local_gemfile)
end
