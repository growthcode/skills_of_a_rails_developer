####### Always #######
gem 'active_model_serializers'
gem 'annotate'
gem 'attribute_normalizer'
gem 'awesome_print'
gem 'colorize','~> 0.7.5'
gem 'factory_bot'
gem 'faker'
gem 'font-awesome-rails'
gem 'jquery-rails' # Dropped in Rails 5.1
gem 'pg'
gem 'pry-rails'

group :development, :test do
  gem 'better_errors' # Better error page for Rack apps (doesn't work when you run "Bundle Exec rails s")
  gem 'bullet' # env development/test: pg, help to kill N+1 queries and unused eager loading
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rack-mini-profiler', require: false
  gem 'rubocop'
  gem 'reek' # https://github.com/troessner/reek; code smells
end

group :development do 
  gem 'binding_of_caller' # this with web-console puts binding on error page in develpment
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
  gem 'timecop' # making it simple to test time-dependent code
end

####### Rails 4, deprecated in 5+ (Always Use) #######
group :development, :test do
  gem "did_you_mean"
  gem 'quiet_assets'
end

####### Rails 5.1.4 (Always Use) #######
# https://github.com/rails/webpacker
gem 'webpacker' # https://mkdev.me/en/mentors/IvanShamatov || https://paweljw.github.io/2017/07/rails-5.1-api-with-vue.js-frontend-part-1-setting-up-a-rails-api-app/
gem 'foreman'

####### Usually Use #######
gem 'acts-as-taggable-on'
gem 'bootstrap-sass', '~> 3.3.7'
gem 'bootswatch-rails'
gem 'devise'
gem 'ejs'
gem 'paper_trail'
gem 'paranoia'
gem 'rolify' # rolify is best but alternative is cancancan
gem 'simple_form'
gem 'unirest' # HTTP api helper I got from mashape.com

####### Efficiency / Analytics / Refactor #######
gem 'pghero' # performance dashboard for Postgres
group :development do
  gem 'meta_request' # Chrome extension for Rails development
  gem 'rails_db' # Rails Database Viewer and SQL Query Runner
  gem 'traceroute' # A Rake task that helps you find dead routes and unused actions in your Rails
  gem 'coverband' # new to me... will update after I've used it, adding now to not forget about it
end

####### Larger Apps #######
gem 'devise_invitable'
gem 'friendly_id' # apply slug to user for friendly URLs
gem 'fullcalendar-rails' # flock calendar (hours / schedule)
gem 'kaminari' # pagination
gem 'kaminari-bootstrap', '~> 3.0.1' # pagination
gem 'pretender' # devise "impersonation" of users
gem 'redis'
gem 'redis-namespace'
gem 'redis-rack-cache'
gem 'redis-rails'
gem 'seedbank' # Seedbank gives your seed data a little structure. Puru used in Flock.
gem 'sidekiq'
gem 'sidekiq-failures' # Keep track of Sidekiq failed jobs
gem 'sidekiq-throttler' # adds the ability to rate limit job execution... like: "when the number of executed jobs for the worker exceeds 50 in an hour, remaining jobs will be delayed"
gem 'whenever', require: false # clear syntax for writing and deploying Cron Jobs (schedule.rb)
# Configuration Needed on Server or local environment:
  # mailcatcher
    # you install the the gem on computer not project... then setup configuration
    # https://mailcatcher.me/

####### Feature Specific #######
gem 'carrierwave'
gem 'carrierwave-aws'
gem 'carrierwave-base64'
gem 'carrierwave-size-validator'
gem 'ckeditor'
gem 'letter_opener_web' # A web interface for browsing Ruby on Rails sent emails
gem 'mini_magick'
gem 'nokogiri' # HTML, XML, SAX, and Reader parsers with XPath and CSS selector support
gem 'pgcrypto' # encrypt fields like ssn in database to binary
gem 'rack-timeout' # Abort requests that are taking too long
gem 'rails-observers' # Rails observer (removed from core in Rails 4.0)
gem 'smarter_csv' # Ruby Gem for smarter importing of CSV Files as Array(s) of Hashes

####### Assets for UI/UX #######
gem 'premailer-rails' # drop in solution for styling HTML emails with CSS
gem 'select2-rails' # better styled selected boxes... use this if you don't have vendor file
gem 'stamp' # easy date time formatting
gem 'StreetAddress', require: 'street_address' # Detect, and dissect, US Street Addresses in strings.
gem 'sweet-alert' # better styled alerts... use this if you don't have vendor file
gem 'x-editable-rails' # css loading bars styles... as text

####### research needed (in Flock but I haven't used it) #######
group :test do
  gem 'database_cleaner'
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'guard-teaspoon'
  gem 'jasmine'
  gem 'poltergeist'
  gem 'shoulda-callback-matchers', '~> 1.1.1'
  gem 'shoulda-matchers', '~> 3.0'
  gem 'simplecov', require: false
  gem 'simplecov-rcov', require: false
  gem 'spork-rails'
  gem 'spring-commands-rspec'
  gem 'spring-commands-teaspoon'
  gem 'teaspoon-jasmine'
  gem 'vcr'
  gem 'webmock'
end


#######################################################
############## Rails Standard '~> 5.1.4' ##############
#######################################################
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
# gem 'turbolinks', '~> 5'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

#######################################################
############## Rails Standard '~> 5.1.4' ##############
#######################################################
