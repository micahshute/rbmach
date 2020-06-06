class Rbmach::Image

    def self.new_from_ubyte(path)
        f = File.open(path)
        img_data = f.read
        num_data = img_data.each_byte.map{ |b| b }
        metadata = num_data[0...16]
        pixels = num_data[16..-1]
        binding.pry
        
    end


    def self.new_from_file(path)

    end

    def initialize(path: nil, rows: nil, columns: nil, greyscale: true, pixels: nil)
        @path, @rows, @columns, @greyscale, @pixels = path, rows, columns, greyscale, pixels
        if !@path
            imgfile = File.open('img.png')

        else

        end
    end

end