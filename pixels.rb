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
  property :ligth, Boolean
  
  # dm timestamp
  
  has n, :clicks
  
  def switch
    self.update :light => !self.light
    self.clicks.new.save
  end
  
  def status
    light ? 'on' : 'off'
  end
end

class Pixel
  include DataMapper::Resource
  
  property :id, Serial
  
  # dm timestamp
  
  belongs_to :pixel
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

post '/pixel_switch' do
  Pixel.first(:id => params[:pixel_id]).switch
end

get '/timestamp_update' do
  content_type :json
  Pixel.all(:updated_at.gt  => params[:last_timestamp]).to_json
end