require 'rubygems'
require 'rest_client'

new_grid = ""
intensity = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F']
increment = 0

432.times do |i|
  val = ((increment + 16*3) % 5) + 8
	new_grid << intensity[val]
	increment += 1
end

#p new_grid
RestClient.post 'http://pixels.tetalab.org/grid', :grid => new_grid