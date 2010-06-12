require 'rubygems'
require 'serialport'

sp = SerialPort.new "/dev/tty.usbserial-A7006Qs0", 38400

while(1) do
  panel = "Z"
  (0..432).each{|row| panel << rand(9)}
  sp.write panel
end