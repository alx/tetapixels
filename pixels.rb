require 'rubygems'
require 'sinatra'
require 'dm-core'

# Configure DataMapper to use the App Engine datastore 
#DataMapper.setup(:default, "appengine://auto")
DataMapper.setup(:default, "sqlite3:///#{Dir.pwd}/test.db")

# Create your model class
class Pixel
  include DataMapper::Resource
  
  property :id, Integer, :key => true
  property :status, Text
end

get '/' do
  # Just list all the shouts
  @pixels = Pixel.all

  unless @pixels.size != 0
   DataMapper.auto_migrate!
   status = ['on', 'off']
    2500.times do |i|
      Pixel.create(:id => i, :status => status[rand(2)])
    end
  end

  erb :index
end

post '/pixel_on' do
  Pixel.first(:id => params[:pixel_id]).update :status => 'on'
end

post '/pixel_off' do
  Pixel.first(:id => params[:pixel_id]).update :status => 'off'
end
