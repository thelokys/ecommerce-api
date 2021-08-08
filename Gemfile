source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

# rails
gem 'rails', '~> 6.0.4'

# postgres database
gem 'pg', '>= 0.18', '< 2.0'

# server
gem 'puma', '~> 4.1'

gem 'bootsnap', '>= 1.4.2', require: false

# auth
gem 'devise_token_auth', '~> 1.1.4'

# For template mailer
gem 'inky-rb', require: 'inky'
# Stylesheet inlining for email
gem 'premailer-rails'

# cors
gem 'rack-cors', '~> 1.1.1'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 4.0.1'
  gem 'factory_bot_rails'
  gem 'shoulda-matchers', '~> 4.0'
  gem 'faker'
  gem 'simplecov'
end

group :development do
  gem 'listen', '~> 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
