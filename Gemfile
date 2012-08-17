source :rubygems

gem 'sinatra'
gem 'sinatra-flash', :require => 'sinatra/flash'
gem 'sinatra-sequel', :require => 'sinatra/sequel'
gem 'rack_csrf', :require => 'rack/csrf'
gem 'erubis'
gem 'json'
gem 'pg'
gem 'sequel'
gem 'httparty'


group :test do
  gem 'shoulda'
  gem 'rack-test', :require => 'rack/test'
end

group :production, :development do
  gem 'unicorn'
end

group :development do
  gem 'awesome_print'
end
