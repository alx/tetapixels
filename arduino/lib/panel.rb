class Panel
  
  attr_accessor :lines
  attr_reader :arduino, :hexgrid, :logger
  
  def initialize(args)
    # retrieve serial port
    @arduino = args[:arduino]
    @logger = args[:logger]
    
    @lines = ["", "", ""]
    
    # http://www.dafont.com/fr/four-pixel-caps.font
    @font = {:a => ["0FFF", "F0F0", "FFFF"],
      :b => ["FFFF", "FF0F", "0FFF"],
      :c => ["0FFF", "F00F", "F00F"],
      :d => ["FFFF", "F00F", "0FF0"],
      :e => ["00FF", "FF0F", "F00F"],
      :f => ["0FFF", "F0F0", "F000"],
      :g => ["FFF0", "F00F", "F0FF"],
      :h => ["FFFF", "0F00", "FFFF"],
      :i => ["FFFF"],
      :j => ["000F", "F00F", "FFF0"],
      :k => ["FFFF", "00F0", "0F0F"],
      :l => ["FFF0", "000F", "000F"],
      :m => ["FFFF", "F000", "FF00", "0FFF"],
      :n => ["FFFF", "F000", "0FFF"],
      :o => ["FFF0", "F00F", "0FFF"],
      :p => ["FFFF", "F0F0", "0FF0"],
      :q => ["FFF0", "F0FF", "FFF0"],
      :r => ["0FFF", "F0F0", "FF0F"],
      :s => ["FF0F", "FF0F", "F0FF"],
      :t => ["F000", "FFFF", "F000"],
      :u => ["FFF0", "000F", "FFFF"],
      :v => ["FFFF", "00F0", "FF00"],
      :w => ["FFFF", "000F", "00FF", "FFF0"],
      :x => ["F0FF", "0FF0", "FF0F"],
      :y => ["FF00", "00FF", "FF00"],
      :z => ["F0FF", "FF0F", "F00F"]}
    
    # build initial hex grid
    @hex_grid = "Z"
    27.times do
      @hex_grid << "0000000000000000"
    end
  end
  
  def no_light(options = {})
    @hex_grid = "Z000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
    write_grid
    sleep options[:seconds] if options[:seconds]
  end
  
  def full_light(options = {})
    @hex_grid = "ZFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF"
    write_grid
    sleep options[:seconds] if options[:seconds]
  end
  
  def random
    values = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"]
    @hex_grid = "Z"
    432.times do 
      @hex_grid << values[rand(16)]
    end
    write_grid
  end
  
  def text(options = {})
    if @lines.size != 3
      @logger.error "Can't display this number of lines: #{@lines.size}"
    else
      @logger.info "lines: #{@lines.inspect}"
      @lines.first.each_char do |letter|
        splitted = @letters[letter].split(".")
        splitted.each do |current_letter|
          @hex_grid = @hex_grid[16..432]
          case current_letter
          when "0"
            index = 0
            @hex_grid += "0000000000000000"
          else
            index += 1
            @hex_grid += current_letter + "00000000000"
          end
          write_grid
        end
      end
    end
  end
  
  def text_screen(lines = [])
    # init lines with 1.2.3. headers on 6 columns
    # @hex_grid = "Z000000F0FF0F00F0"
    # @hex_grid << "00F000FFFF0FF0F0"
    # @hex_grid << "0FFFF0FF0F000FF0"
    # @hex_grid << "0000000000000000"
    # @hex_grid << "0000F0000F0000F0"
    # @hex_grid << "0000000000000000"
    header = "Z000000F0FF0F00F000F000FFFF0FF0F00FFFF0FF0F000FF000000000000000000000F0000F0000F00000000000000000"
    
    # init text scroll array that will be empty first
    text_scroll = ["0000000000000000","0000000000000000","0000000000000000","0000000000000000","0000000000000000","0000000000000000","0000000000000000","0000000000000000","0000000000000000","0000000000000000","0000000000000000","0000000000000000","0000000000000000","0000000000000000","0000000000000000","0000000000000000","0000000000000000","0000000000000000","0000000000000000","0000000000000000","0000000000000000"]
    
    # init position of the letter read inside the word
    position = [-1, -1, -1]
    # init buffer that will store each letter
    char_buffer = [[], [], []]
    
    while true do
      
      # init font array (bug: outside array, letters will disappear from the hash)
      font = {:a => "0FFFF0F0FFFF",
        :b => "FFFFFF0F0FFF",
        :c => "0FFFF00FF00F",
        :d => "FFFFF00F0FF0",
        :e => "00FFFF0FF00F",
        :f => "0FFFF0F0F000",
        :g => "FFF0F00FF0FF",
        :h => "FFFF0F00FFFF",
        :i => "FFFF",
        :j => "000FF00FFFF0",
        :k => "FFFF00F00F0F",
        :l => "FFF0000F000F",
        :m => "FFFFF000FF000FFF",
        :n => "FFFFF0000FFF",
        :o => "FFF0F00F0FFF",
        :p => "FFFFF0F00FF0",
        :q => "FFF0F0FFFFF0",
        :r => "0FFFF0F0FF0F",
        :s => "FF0FFF0FF0FF",
        :t => "F000FFFFF000",
        :u => "FFF0000FFFFF",
        :v => "FFFF00F0FF00",
        :w => "FFFF000F00FFFFF0",
        :x => "F0FF0FF0FF0F",
        :y => "FF0000FFFF00",
        :z => "F0FFFF0FF00F"}
        
      # Set empty line on the column
      current_column = "0"
      
      # Set index of the line currently read
      index = 0
      
      buffer = []
      
      lines.each do |text|
        
        # Character buffer is empty and needs to be filled
        if char_buffer[index].nil? || char_buffer[index].empty?
          # WRITE: use empty space for this loop
          current_column << "00000"
          # Set the text position index to the next letter
          position[index] += 1
          # If word is finished, reset the position index
          position[index] = 0 if lines[index].length == position[index]
          # Fill the character buffer with the corresponding character
          char_buffer[index] = font[lines[index][position[index]].chr.to_sym]
        else
          # WRITE: use first 4 pixels of the buffer for this line
          current_column << char_buffer[index][0...4] << "0"
          # remove the part of the buffer that was just read
          char_buffer[index].gsub!(/^.{4}/, "")
        end
        # go to read the next work in the lines 
        index += 1 
      end
      
      # remove the first column from the scrolling text
      text_scroll.shift
      # add the last column of the scrolling text
      text_scroll.push(current_column)
      # join header and scrolling text to the new grid to be displayed
      @hex_grid = header + text_scroll.join("")
      write_grid
    end
    
  end
  
  def write_grid
    @arduino.serial_port.write @hex_grid
  end
  
end