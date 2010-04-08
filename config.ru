require 'rubygems'
require 'sinatra'
require 'pixels'

FileUtils.mkdir_p 'log' unless File.exists?('log')
log = File.new("log/sinatra.log", "a")
$stdout.reopen(log)
$stderr.reopen(log)


set :run, false
set :environment, ENV['RACK_ENV']
run Sinatra::Application
