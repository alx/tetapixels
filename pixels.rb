require 'rubygems'
require 'sinatra'

gem 'dm-core'
gem 'dm-timestamps'

require 'dm-core'
require 'dm-timestamps'

DataMapper.setup(:default, "sqlite3:///#{Dir.pwd}/test.db")

configure do
  LOGGER = Logger.new("sinatra.log") 
end

helpers do
  def logger
    LOGGER
  end
end

class Grid
  include DataMapper::Resource
  
  property :id, Serial
  property :hex_grid, String
  property :pixel_count, Integer
  
  property :updated_at, DateTime
  
  has n, :pixels
  
  def initialize
    self.pixel_count = 432
  end
  
  def update_pixel(pixel_id, status)
    grid = self.hex_grid
    grid[pixel_id] = status
    p "update grid: #{grid[0..10]} - pixel: #{pixel_id} - status: #{status}"
    self.update! :hex_grid => grid
    p "hexgrid: #{hexgrid[0..10]}"
  end
  
  def generate_random_grid
    values = ['0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F']
    grid = " " * self.pixel_count
    self.pixel_count.times do |i|
      # use index to start index at 1
      pixel = self.pixels.new(:id => i, :light => rand(2), :gradient => values[rand(16)])
      pixel.save
      grid[i] = pixel.gradient
    end
    self.update! :hex_grid => grid
  end
  
end

class Pixel
  include DataMapper::Resource
  
  property :id, Integer, :key => true
  property :light, Boolean
  property :gradient, String
  
  property :updated_at, DateTime
  
  belongs_to :grid
  has n, :clicks
  
  def switch(new_gradient)
    self.update :gradient => gradient
    Grid.first.update_pixel(self.id, new_gradient)
    
    click = self.clicks.new :gradient => new_gradient
    click.save
  end
end

class Click
  include DataMapper::Resource
  
  property :id, Serial
  property :gradient, String
  
  property :created_at, DateTime
  
  belongs_to :pixel
end

get '/' do
  begin
    @grid = Grid.first
  rescue
    DataMapper.auto_migrate!
    @grid = Grid.new
    @grid.save
    @grid.generate_random_grid
  end

  erb :index
end

get '/grid' do
  Grid.first.hex_grid
end

post '/grid' do
  grid = Grid.first
  if params[:grid] && params[:grid].size == grid.pixel_count
    grid.update(:hex_grid => params[:grid])
  end
end

post '/pixel_switch' do
  p "Switch pixel[#{params[:pixel_id]}]: #{params[:gradient]}"
  Pixel.first(:id => params[:pixel_id]).switch(params[:gradient])
end