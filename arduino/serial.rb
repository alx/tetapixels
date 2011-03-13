require 'rubygems'
require 'serialport'
require 'find'

def connect_arduino
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
    sp = SerialPort.new arduino_tty, 38400
    p "Arduino connected on #{arduino_tty}"
  else
    p "404: Arduino not found"
    Process.exit
  end
  
  return sp
end

sp = connect_arduino


maj = {"a" => "99999.99999.99999.99999.0",
       "b" => "99999.90909.99909.00999.0",
       "c" => "99999.90009.90009.90009.0",
       "d" => "99999.90009.90009.09990.0",
       "e" => "99999.90909.90909.90909.0",
       "f" => "99999.90900.90900.90900.0",
       "g" => "99999.90009.90909.90999.0",
       "h" => "99999.00900.00900.99999.0",
       "i" => "90009.99999.90009.0",
       "j" => "00099.00009.90009.99999.0",
       "k" => "99999.00900.00900.99099.0",
       "l" => "99999.00009.00009.00009.0",
       "m" => "99999.90000.99999.90000.99999.0",
       "n" => "99999.09000.00900.99999.0",
       "o" => "99999.90009.90009.99999.0",
       "p" => "99999.90090.90090.99990.0",
       "q" => "99999.90009.90099.99999.0",
       "r" => "99999.90900.90999.99909.0",
       "s" => "99909.90909.90909.90999.0",
       "t" => "90000.99999.90000.0",
       "u" => "99999.00009.00009.99999.0",
       "v" => "99990.00009.00990.99000.0",
       "w" => "99999.00009.99999.00009.99999.0",
       "x" => "99099.00900.00900.99099.0",
       "y" => "99909.00909.00909.99999.0",
       "z" => "90099.90909.90909.99009.0",
       " " => "00000.00000.00000.0"}
# 
# hex_grid = "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"

index = 0

def light(sp, column, line)
  hex_grid = "Z"
  
  for i in (1..27)
    if(column == i)
      hex_grid << "0000000000000000"
    else
      hex_grid << line
    end
  end
  
  sp.write hex_grid
end

while(1) do
  # hex_grid = "Z"
  # for column in (1..27)
  #   hex_grid << "FFFFFFFFFFFFFFFF"
  # end
  # sp.write hex_grid
  for column in (1..27)
    light sp, column, "A000000000000000"
    light sp, column, "0A00000000000000"
    light sp, column, "00A0000000000000"
    light sp, column, "000A000000000000"
    light sp, column, "0000A00000000000"
    light sp, column, "00000A0000000000"
    light sp, column, "000000A000000000"
    light sp, column, "0000000A00000000"
    light sp, column, "00000000A0000000"
    light sp, column, "000000000A000000"
    light sp, column, "0000000000A00000"
    light sp, column, "00000000000A0000"
    light sp, column, "000000000000A000"
    light sp, column, "0000000000000A00"
    light sp, column, "00000000000000A0"
    light sp, column, "000000000000000A"
    light sp, column, "00000000000000A0"
    light sp, column, "0000000000000A00"
    light sp, column, "000000000000A000"
    light sp, column, "00000000000A0000"
    light sp, column, "0000000000A00000"
    light sp, column, "000000000A000000"
    light sp, column, "00000000A0000000"
    light sp, column, "0000000A00000000"
    light sp, column, "000000A000000000"
    light sp, column, "00000A0000000000"
    light sp, column, "0000A00000000000"
    light sp, column, "000A000000000000"
    light sp, column, "00A0000000000000"
    light sp, column, "0A00000000000000"
  end
  
  

  
  # "aaaaaaaaaa".each_char do |letter|
  #   splitted = maj[letter].split(".")
  #   splitted.each do |current_letter|
  #     hex_grid = hex_grid[16..432]
  #     case current_letter
  #     when "0"
  #       index = 0
  #       hex_grid += "0000000000000000"
  #     else
  #       index += 1
  #       hex_grid += current_letter + "00000000000"
  #     end
  #     
  #     hex_grid = hex_grid[0...(15*16)] + hex_grid[(15*16)...(16*16)].reverse + hex_grid[(16*16)...(17*16)].reverse + hex_grid[(17*16)...432]
  #     
  #     sp.write "Z" + hex_grid
  #   end
  # end
  # panel = "Z"
  # (0..432).each_with_index do |row, index|
  #   puts "index #{index} - hex_grid[index] #{hex_grid[index].to_s}"
  #   if hex_grid[index].to_s == "48"
  #     hex_grid[index] = ["0","F"][rand(2)]
  #   end
  #   if hex_grid[index].to_s == "70"
  #     hex_grid[index] = ["0","F"][rand(2)]
  #   end
  # end
  # sp.write "Z" + hex_grid 
  
end

# 
# maj = {:a => "FFFFF.F0F00.F0F00.FFFFF",
#       :b => "FFFFF.F0F0F.FFF0F.00FFF",
#       :c => "FFFFF.F000F.F000F.F000F",
#       :d => "FFFFF.F000F.F000F.0FFF0",
#       :e => "FFFFF.F0F0F.F0F0F.F0F0F",
#       :f => "FFFFF.F0F00.F0F00.F0F00",
#       :g => "FFFFF.F000F.F0F0F.F0FFF",
#       :h => "FFFFF.00F00.00F00.FFFFF"
#       :i => "F000F.FFFFF.F000F",
#       :j => "000FF.0000F.F000F.FFFFF",
#       :k => "FFFFF.00F00.00F00.FF0FF",
#       :l => "FFFFF.0000F.0000F.0000F"
#       :m => "FFFFF.F0000.FFFFF.F0000.FFFFF",
#       :n => "FFFFF.0F000.00F00.FFFFF",
#       :o => "FFFFF.F000F.F000F.FFFFF",
#       :p => "FFFFF.F00F0.F00F0.FFFF0"
#       :q => "FFFFF.F000F.F00FF.FFFFF",
#       :r => "FFFFF.F0F00.F0FFF.FFF0F",
#       :s => "FFF0F.F0F0F.F0F0F.F0FFF",
#       :t => "F0000.FFFFF.F0000"
#       :u => "FFFFF.0000F.0000F.FFFFF",
#       :v => "FFFF0.0000F.00FF0.FF000",
#       :w => "FFFFF.0000F.FFFFF.0000F.FFFFF",
#       :x => "FF0FF.00F00.00F00.FF0FF"
#       :y => "FFF0F.00F0F.00F0F.FFFFF",
#       :z => "F00FF.F0F0F.F0F0F.FF00F"}
# 
# num = ["FFFFF.F000F.F000F.FFFFF",
#   "F0000.FFFFF", 
#   "F0FFF.F0F0F.F0F0F.FFF0F",
#   "F0F0F.F0F0F.F0F0F.FFFFF",
#   "FFFF0.000F0.000F0.FFFFF",
#   "F0FFF.F0F0F.F0F0F.FFF0F",]
