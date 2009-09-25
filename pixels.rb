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
  property :binary_grid, String
  property :pixel_count, Integer
  
  property :updated_at, DateTime
  
  has n, :pixels
  
  def initialize
    self.pixel_count = 2500
  end
  
  def update_pixel(pixel_id, status)
    grid = self.binary_grid
    grid[pixel_id] = status
    self.update_attributes :binary_grid => grid
  end
  
  def generate_random_grid
    grid = " " * self.pixel_count
    self.pixel_count.times do |i|
      # use index to start index at 1
      status = rand(2)
      pixel = self.pixels.new(:id => i, :light => status)
      pixel.save
      grid[i] = status.to_s
    end
    self.update_attributes :binary_grid => grid
  end
  
end

class Pixel
  include DataMapper::Resource
  
  property :id, Integer, :key => true
  property :light, Boolean
  
  property :updated_at, DateTime
  
  belongs_to :grid
  has n, :clicks
  
  def switch
    if self.light == true
      self.update_attributes :light => false
      self.grid.update_pixel(self.id, '0')
    else
      self.update_attributes :light => true
      self.grid.update_pixel(self.id, '1')
    end
    click = self.clicks.new
    click.save
  end
  
  def status
    light ? 'on' : 'off'
  end
end

class Click
  include DataMapper::Resource
  
  property :id, Serial
  
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

post '/pixel_switch' do
  Pixel.first(:id => params[:pixel_id]).switch
end