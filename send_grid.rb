require 'rubygems'
require 'rest_client'

new_grid = ""
intensity = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F']
line = 0

432.times do |i|
  p line
  if line % 8 != 0
    row = 16*line - i 
    p row
    if row > 3 && row < 11
	    new_grid << '2'
    else
      new_grid << '0'
    end
  else
    new_grid << '0'
  end
  
  if i%16 == 0
	  line += 1
  end
end

p "#{new_grid}"
  
RestClient.post 'http://pixels.tetalab.org/grid', :grid => new_grid
