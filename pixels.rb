require 'rubygems'
require 'sinatra'

gem 'dm-core', '=0.9.11' 
gem 'dm-timestamps', '=0.9.11'

require 'dm-core'
require 'dm-timestamps'

DataMapper.setup(:default, "sqlite3:///#{Dir.pwd}/test.db")

set :logging, false

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
    self.update_attributes :hex_grid => grid
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
    self.update_attributes :hex_grid => grid
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
    
    self.gradient = new_gradient
    
    if self.light == true && self.gradient == '0'
      self.light = false
    elsif self.light == false && gradient == 'F'
      self.light = true
    end
    
    self.save
    
    self.grid.update_pixel(self.id, new_gradient)
    
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

post '/pixel_switch' do
  Pixel.first(:id => params[:pixel_id]).switch(params[:gradient])
end

get '/last' do
  params[:limit] ||= 10
  params[:offset] ||= 0
  pixels = []
  Click.all(:limit => params[:limit].to_i,
            :offset => params[:offset].to_i,
            :order => [:created_at.desc]).each do |click|
    pixels << click.pixel.id
  end
  pixels.inspect
end

get '/updates' do
  @grid = Grid.first
  @grid.pixels.all(:updated_at.gt => Time.at(params[:timestamp].to_i)).to_json  
end