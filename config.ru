#!/usr/bin/env rackup

require File.join(File.dirname(__FILE__), 'config/boot.rb')

use Rack::MethodOverride
use Rack::Session::Cookie
use Rack::Csrf, :raise => true

require './app.rb'
run SerusuFoji

