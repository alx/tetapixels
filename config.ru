require 'rubygems'
require 'sinatra'
require 'pixels'

set :run, false
set :environment, ENV['RACK_ENV']
run Sinatra::Application