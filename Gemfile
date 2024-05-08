source "https://rubygems.org"

gemspec

# load local gemfile
['Gemfile.local.rb', 'Gemfile.local'].map do |file_name|
  local_gemfile = File.join(File.dirname(__FILE__), file_name)
  self.instance_eval(Bundler.read_file(local_gemfile)) if File.exist?(local_gemfile)
end

gem 'gettext', '>= 3.1.3', '< 4.0.0'

group :test do
  gem 'ci_reporter_minitest', :require => false
  gem 'minitest', '~> 5.18'
  gem 'minitest-spec-context', '~> 0.0.5'
  gem 'mocha', '~> 2.0'
  gem 'rake', '~> 10.0'
  gem 'rubocop', '0.42'
  gem 'thor', '~> 1.0'
end
