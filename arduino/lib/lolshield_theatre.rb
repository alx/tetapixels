class LolShieldTheatre

  attr_reader :panel, :logger, :api_url

  def initialize(args)
     @panel = args[:panel]
     @logger = args[:logger]
     @api_url = "http://falldeaf.com/lolshield/robot_xml.php"
  end

  def feed(type) 
    xml = Nokogiri::XML::Reader(open(@api_url + "?feed=#{type}"))
    xml.css("LED").first do |led_anim|
       led_anim.css("frame").each do |frame|
         @panel.hex_grid = convert_lines(frame.css('line'))
         sleep led_anim.css('delay').content.to_i
       end
    end
  end

  private

  def convert_lines(lines)
    hex_grid = "Z"

    # init empty grid
    9.times do
      14.times do
        hex_grid << "0"
      end
    end

    # convert each line to hex_grid
    lines.each do |line|
      line_index = line.attr('lnID').to_i
      binary_line = line.content.to_i
      column_index = 13
      [8192, 4096, 2048, 1024, 512, 256, 128, 64, 32, 16, 8, 4, 2, 1].each do |binary|
        if(binary_line >= binary)
          hex_grid[(9 * column_index) + line_index]
          binary_line -= binary
        end
        column_index += 1
      end
    end

    # insert empty chars to comply with ledpong size
    13.times do |position|
      hex_grid.insert(9 * (13 - insert_position), "0000000")
    end

    return hex_grid
  end
end
