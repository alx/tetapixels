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
  
  
else
  logger.info "404: Arduino not found"
end          
