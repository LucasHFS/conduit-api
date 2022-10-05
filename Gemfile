source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.4"

gem "rails", "~> 7.0.3"

gem "pg", "~> 1.1"
gem "puma", "~> 5.0"

gem 'jbuilder', '~> 2.11'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem 'rswag-api', '~> 2.5'
gem 'rswag-ui', '~> 2.5'

gem "bootsnap", require: false

gem "devise", "~> 4.8"
gem "jwt", "~> 2.5"

group :development, :test do
  gem 'debug', platforms: %i[mri mingw x64_mingw]

  gem 'rspec-rails', '~> 5.1'
  gem 'factory_bot_rails', '~> 6.2.0'
  gem 'faker', '~> 2.21.0'
  gem 'pry', '~> 0.14.1'

  gem 'rdoc'
  gem 'rswag-specs', '~> 2.5'
  gem 'rubocop', '~> 1.30'
  gem 'rubocop-performance', '~> 1.14'
  gem 'rubocop-rails', '~> 2.14'
  gem 'rubocop-rspec', '~> 2.11'
  gem 'shoulda-matchers', '~> 5.1'
  gem 'simplecov', '~> 0.21.2'
  gem 'super_diff', '~> 0.9.0'
end

gem "acts-as-taggable-on", "~> 9.0"
