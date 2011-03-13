class Arduino
  
  attr_reader :serial_port
  
  def initialize
    arduino_tty = ""
    Find.find("/dev") do |path|
      unless FileTest.directory?(path)
        if File.basename(path).match /^tty\.usb.*/
          arduino_tty = path
          Find.prune
        else
          next
        end
      end
    end

    unless arduino_tty.empty?
      @serial_port = SerialPort.new arduino_tty, 38400
    end
  end
end