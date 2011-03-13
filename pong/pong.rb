require 'rubygems'
require 'serialport'
require 'find'

def connect_arduino
  arduino_tty = ""
  Find.find("/dev") do |path|
    unless FileTest.directory?(path)
      if File.basename(path).match /^tty\.usbserial-.*/
        arduino_tty = path
        Find.prune
      else
        next
      end
    end
  end

  unless arduino_tty.empty?
    sp = SerialPort.new arduino_tty, 38400
    p "Arduino connected on #{arduino_tty}"
  else
    p "404: Arduino not found"
  end
  
  return sp
end

sp = connect_arduino

table = "
0000000000000F0000000000000
0000000000000F0000000000000
0000000000000F0000000000000
0000000000000F0000000000000
0000000000000F0000000000000
0000000000000F0000000000000
0000000000000F0000000000000
0000000000000F0000000000000
0000000000000F0000000000000
0000000000000F0000000000000
0000000000000F0000000000000
0000000000000F0000000000000
0000000000000F0000000000000
0000000000000F0000000000000
0000000000000F0000000000000
0000000000000F0000000000000
"

ball_x = 0
ball_y = 8

ball_dir = "right"

while(true) do
  
  # Set Ball X
  ball_dir == "right" ? ball_x += 1 : ball_x -= 1
  
  if ball_x == 0
    ball_dir = "right"
  end
  
  if ball_x == 27
    ball_dir = "left"
  end
end