source 'https://rubygems.org'
ruby '2.2.1'
#ruby-gemset=load_generator

gem 'rails', '4.2.1'

### Debugging
gem 'pry'
gem 'pry-rails' # Use pry as Rails console

### Assets
gem 'less-rails', '~> 2.7.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

group :development do
  gem 'thin'
  gem 'pry-byebug' # Use pry as debugger with step, next, finish, continue
  gem 'rb-readline' # Fixes guard issues with interactive pry
end

group :development, :test do
  gem 'sqlite3'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :production do
  gem 'unicorn'
  gem 'pg'
  gem 'execjs'
end

group :doc do
  # Generate docs with `yard doc`
  gem 'yard', '~> 0.8.7.6'
end
