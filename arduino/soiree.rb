require 'rubygems'
require 'serialport'
require 'find'
require 'logger'

require 'lib/arduino'
require 'lib/panel'

logger = Logger.new(STDOUT)
logger.level = Logger::WARN

arduino = Arduino.new

if(arduino.serial_port)
  
  logger.info "Arduino connected"
  
  panel = Panel.new({:arduino => arduino, :logger => logger})
  
  text = [
    "futurs robots party  ",
    "mixart myrys  ", 
    "tetalab wikileaks ccc arduino reprap tangible hackers electronique resistance"
  ]
  
  while(1)
    # panel.no_light({:seconds => 1})
    # panel.full_light({:seconds => 1})
    # panel.random
    panel.text_screen text
  end
  
else
  logger.info "404: Arduino not found"
end