# frozen_string_literal: true

source "https://rubygems.org"

gemspec
# TODO: seems like this should be fixed in ruby_parser 🤔
gem "racc", '~> 1.7.3', platforms: [:ruby_33]

group :development do
  gem 'appraisal'
  gem 'byebug'
end

group :test do
  gem 'benchmark'
  gem 'rake', '~> 13.3.1'
  gem 'rspec', '~> 3.12.0'
end
