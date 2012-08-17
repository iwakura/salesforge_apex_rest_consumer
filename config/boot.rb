require 'rubygems'
require 'bundler'

Bundler.require

set :database, ENV['DATABASE_URL']

migration 'creating table sf_users' do
  database.create_table :sf_users do
    primary_key :id
    String :instance_url,  :null => false, :default => ''
    String :refresh_token, :null => false, :default => ''
    String :token,         :null => false, :default => ''
    String :uid,           :null => false, :default => ''
  end
end

APP_CONFIG = YAML.load_file(File.join(File.dirname(__FILE__), 'omniauth.yml'))

$:.unshift File.join(File.dirname(__FILE__), '../models')

require 'sf_user'
require 'sf_client'
require 'account'


