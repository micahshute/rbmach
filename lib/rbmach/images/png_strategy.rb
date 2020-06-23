class Rbmach::PNGStrategy

    # "\x89PNG\r\n\u001A\n\u0000\u0000\u0000\rIHDR\u0000\u0000\u0006\x89\u0000\u0000\u0003\xC8\b\u0002\u0000\u0000\u0000\x8A\u001F\x85\x89\u0000\u0000,\x93zTXtRaw profile type exif\u0000\u0000xڭ\x9Cir\\9\x92\xAD\xFFc\u0015\xB5\u0004\xCC\xC3r\u00008`\xF6v\xD0\xCB\xEF\xEF HeRʲ\xEE\xB2גI\xA2\x82\u0011\xF7bp?\x83\xC3/\xDD\xF9\xAF\xFFwݿ\xFE\xF5\xAF\xE0s\xAC.\x97\xD6\xEB\xA8\xD5\xF3+\x8F<\xE2\xE4\x8B\xEE?\xBF\xF6\xFB\x9B7\xBE\xBF߯>|\xFDz\xF5\xC7\xEBnw\x9F\xDEW\x91\x97\xF4\xD5\xE7\u007F~\x9C\xAF\x8B]^\x8F\xFC[>\xFF\x9D\xD9\u007F]\xE7\xEB\xF5\xAF\x9B\xBA9\xBF\xBE\xF1}\xA1\xAF;|\xFF\e&_\x95\xBF\xFE\xBF\xE2\xD7\xEB\xEB\xE7\xEBn}](\xF6\xDF.\xF4\xF5\x81\u0014\xBE\xEEl_\xB3\xFD~=~^\u000F_#t_\xDF\xF7u\xF4\xF6\xF79\x9F\xAF7\x94\xFD5\xD9\xFEן\x92\xF2ͧ\x8C\xAFu\xDD9\xE5⢥V\xB8r\xEE?\xA7\xF4\xC7\xFF\e\u001F\xB1\xC2 R\x8C'\x85\xE4\xDF\xDF\xF93\xBA\xE4\x9D\xFEJ\x93?\xE1\xF3w\xD4W\xFA\xBA\xA4\xC6\xDF1q\xDF\xC8Z\x8C\xD9\xE3\xDF\xD7d\xD6\xCF\xE4\x87}^w\xBF\xBEq>߈\xB1\xF7\u007FZ\xF4\xD8~\xBE~\xF3\xE7\xAB\xE4?\xAF\xBB?\u0016W\u0017\xCA\u007F~\x80{{\xDF4ǯ\xF7iB\x89+\xBC!s\xA1\xEFU__Ce\xF5\xFC\xDFwcϯ\xD7È~\xFEu\u0003\xFB\x9A\x81\x8F\xE3\xE7\xD4\xCE\xF7\x85\xD2\xCF\u000F\x9C\xF3\xEB\u0006?^\xBF\xDF\xEF/\xBF]\xE8~\u007F\xA0\u{4DFEF}\xD1WD\x93\e?_\xFF\xFE5>\xAF\xFF\xBAЯ\xEF\xCF\xF1cwȬ\xF4\u001D\xE2\xFF\xB4\t^ə\xFFv!\xFB,%o\xFE|\xE3\x8F\xD7\xCF\xFCy\x83\xF3u\x83;\u007FN-|\xDD9\xF8\xF9s\n\xE9\xD7Pӻ\xE4\uFBC7\xCF\xEB\u0006\xF2\xFB\x9F\xD6\"\xFE\xF6\xFA\xAF\v~^w\u007F| \xF3\x8D\xBFM!|O\xA1\xFC\xBCP\xF8\x95\xA4\xFF\xEEB\xFDߌh\xFC\x9B\xD7翹P\x8A_#\xFA\n\xC8\xF8\xB5vI#U\xA0~\x85C\xAE\u007F\xADރ\x91\xEF\v\xA5\xFD=\xA2\x9Fk\xF0\x92:\xBC\u0004\xF6\xA4\x84\xFE\u001E/\xB13_\xE7\x97\xDE!i\xD7\xFE\xB7o\xDC+\x86\xF2\"#G\xE0\xD7\u007F!\xF7_\bYs\xFC\u001E\xCB\xFC9\xF7\xBF\x96\xFF\xEF\u001F\x89\xF1\xEB\xA3_߯\xADvb5\xBB\xEF\xB9|\xBF\xF0\xFD\xFF\xDFwy\xFEv\x83r~^\xD0\xC5\xFE\xF

    REQUIRED_CHUNKS = [
        :IHDR,
        :IDAT,
        :IEND
    ]

    COLOR_TYPES = {
        greyscale: 0,
        rgb: 2,
        pallet: 3,
        greyscale_alpha: 4,
        rgba: 6
    }

    def self.read(path: nil, data: nil)
        raise ArgumentError.new(".read must be initialized with a path or a datastream") if (path.nil? && data.nil?) || (!path.nil? && !data.nil?)
        raise ArgumentError.new("data must be an array of byte integers or a byte string") if data && !data.is_a?(Array) && !data.is_a?(String)
        raise ArgumentError.new("data must be an array of byte integers or a byte string") if data && data.is_a?(Array) && !data.first.is_a?(Integer) 
        if path
            data = File.read(path).bytes
        else
            data = data.bytes if data.is_a?(String)
        end
        chunk_start = 8
        chunks = []
        loop do 
            len_end = chunk_start + 4
            type_end = len_end + 4
            len = DatX.buf2int(data[chunk_start...len_end])
            type = data[len_end...type_end]
            chunk_end = type_end + len + 4
            case type.pack("C*")
            when "IHDR"
                chunks << Chunk.readIHDR(data[chunk_start...chunk_end])
            when "IDAT"
                chunks << Chunk.readIDAT(data[chunk_start...chunk_end])
            else
                # binding.pry
                chunks << data[chunk_start...chunk_end]
            end

            chunk_start = chunk_end
            break if chunk_end >= data.length - 1

        end

        chunks
        width = chunks.first[:width]
        height = chunks.first[:height]
        bit_depth = chunks.first[:bit_depth]
        color_type = chunks.first[:color_type]
        compression_method = chunks.first[:compression_method]
        filter_method = chunks.first[:filter_method]
        interlace_method = chunks.first[:interlace_method]
        # bits_per_pixel = color_type == 2 || color_type == 6 ? (bit_depth * 3) : bit_depth
        all_idats = chunks.filter{ |c| c.is_a?(Hash) && c[:type] == "IDAT" }
        compressed_pixels = all_idats.reduce([]){ |mem, idat| mem + idat[:compressed_pixels] }
        pixels_and_filter = Zlib::Inflate.inflate(compressed_pixels.pack("C*")).unpack("C*")
        # pixel_width = color_type == 2 || color_type == 6 ? width * 3 : width
        case color_type
        when 0
            pixel_width = width
        when 2
            pixel_width = width * 3
        when 3
            pixel_width = width 
        when 4
            pixel_width = width * 2
        when 6
            pixel_width = width * 4
        else
            raise ArgumentError.new("#{color_type} is not a valid color type. Must be 0,2,3,4, or 6")
        end
        pixels = pixels_and_filter.filter.with_index{ |_,i| i % (pixel_width + 1) != 0}
        # binding.pry
        new(pixels: pixels, type: color_type, width: width, height: height, bit_depth: bit_depth)

    end
    
    attr_reader :pixels, :width, :height, :bit_depth

    def initialize(pixels: nil, type: nil, width: , height: , bit_depth: 8)
        @pixels, @width, @height = pixels, width, height
        @bit_depth = bit_depth
        @type = type.is_a?(Integer) ? type : COLOR_TYPES[type]
        raise ArgumentError("#{type} is not a valid color type. Please use one of: #{COLOR_TYPES.keys}") if type.nil?
        @signature = [137, 80, 78, 71, 13, 10, 26, 10]
        @chunks = [
            Chunk.IHDR(width: @width, height: @height, bit_depth: @bit_depth, color_type: @type),
            *Chunk.IDATs(pixels, color_type: @type, bit_depth: @bit_depth, width: @width, height: @height),
            Chunk.IEND
        ]

    end

    def type
        COLOR_TYPES.each do |k,v|
            return k if v == @type
        end
    end

    def bytes
        all_data.pack("C*")
    end

    def write(path: 'output')
        File.write("./" + path + ".png", bytes)
    end

    private

    def all_data 
        @signature + @chunks.map(&:data).flatten 
    end
   


    class Chunk

        @@crc_table = {}

        def self.readIHDR(bytes)
            bytes = bytes.bytes if bytes.is_a?(String)
            raise ArgumentError.new("IHDR must be 25 bytes long") if bytes.length != 25
            crc = bytes[-4..-1]

            
            data = {}
            data[:length] = DatX.buf2int(bytes[0...4])
            data[:type] = DatX.buf2hex(bytes[4...8])
            data[:width] = DatX.buf2int(bytes[8...12])
            data[:height] = DatX.buf2int(bytes[12...16])
            data[:bit_depth] = bytes[16]
            data[:color_type] = bytes[17]
            data[:compression_method] = bytes[18]
            data[:filter_method] = bytes[19]
            data[:interlace_method] = bytes[20]

            chunk_data = bytes[8...21]
            raise CRCError.new("CRC does not match expected") if !crc_valid?(type: data[:type].unpack("C*"), data: chunk_data, crc: crc)

            data
        end

        def self.readIDAT(bytes)
            bytes = bytes.bytes if bytes.is_a?(String)

            data = {}
            data[:length] = DatX.buf2int(bytes[0...4])
            data[:type] = DatX.buf2hex(bytes[4...8])
            data[:compressed_pixels] = bytes[8...(data[:length] + 8)]
            data
        end

        def self.crc_valid?(type:, data:, crc:)
            c = new(type: type, data: data)
            c.bytes[-4..-1].bytes == crc
        end

        def self.IHDR(width: , height: , bit_depth: , color_type: , compression_method: 0, filter_method: 0, interlace_method: 0)
            bit_depth_rules = {
                0 => [1,2,4,8,16],
                2 => [8, 16],
                3 => [1,2,4,8],
                4 => [8,16],
                6 => [8,16]
            }
            raise ArgumentError.new("Width or height cannot be 0") if width == 0 || height == 0
            test_length(width)
            test_length(height) 
            raise ArgumentError.new('Color code types must be 0, 2, 3, 4, or 6') if ![0,2,3,4,6].include?(color_type)
            raise ArgumentError.new('Bit depth must be related to color_type as such: #{bit_depth_rules}') if !bit_depth_rules[color_type].include?(bit_depth) 


            wbytes = to_bytelen(4, DatX.hex(width).bytes)
            hbytes = to_bytelen(4, DatX.hex(height).bytes)
            bdbyte = [bit_depth]
            ctbyte = [color_type]
            cmbyte = [compression_method]
            fmbyte = [filter_method]
            ilmbyte = [interlace_method]
            data = wbytes + hbytes + bdbyte + ctbyte + cmbyte + fmbyte + ilmbyte
            Chunk.new(type: "IHDR", data: data) 
        end

        def self.PLTE(data)
            data = data.bytes if data.is_a?(String)
            raise ArgumentError.new("Number of bytes must be a multiple of 3") if data.length % 3 != 0
            Chunk.new(type: "PLTE", data: data)
        end

        def self.IDATs(pixels, color_type: ,bit_depth:, width: , height: , idat_size: 2 ** 20)

            case color_type
            when 0
                pixel_width = width
            when 2
                pixel_width = width * 3
            when 3
                pixel_width = width 
            when 4
                pixel_width = width * 2
            when 6
                pixel_width = width * 4
            else
                raise ArgumentError.new("#{color_type} is not a valid color type. Must be 0,2,3,4, or 6")
            end
            expected_pixels = pixel_width * height
            raise ArgumentError.new("pixel count (#{pixels.length}) does not match expected pixel count (#{expected_pixels})") if pixels.length != expected_pixels
            pixel_square = Array.new(height, nil)
            pixel_square = pixel_square.map{ |_| [nil] * pixel_width}
            for i in 0...pixels.length
                row = i / pixel_width
                col = i % pixel_width
                pixel_square[row][col] = pixels[i]
            end

            scanlines = pixel_square.map do |bit_strm|

                case bit_depth
                when 1
                    [0] + DatX.hex(bit_strm.map{|b| b.to_s(2)}.join('').to_i(2))
                when 2
                    [0] + DatX.hex(bit_strm.map{|b| DatX.pad(num: b.to_s(2), len: 2)}.join('').to_i(2))
                when 4
                    [0] + DatX.hex(bit_strm.map{|b| DatX.pad(num: b.to_s(2), len: 4)}.join('').to_i(2))
                when 8
                    ([0] + bit_strm).pack("C*")
                when 16
                    ([0] + bit_strm).pack("S*")
                else
                    ArgumentError.new("bit_depth can only be 1,2,4,8, or 16 bits")
                end

            end

            # zstrm = Zlib::Deflate.new(
            #     Zlib::BEST_COMPRESSION,
            #     Zlib::MAX_WBITS,
            #     Zlib::MAX_MEM_LEVEL,
            #     Zlib::RLE
            # ).deflate(scanlines.join(''))
            z = Zlib::Deflate.new(Zlib::BEST_COMPRESSION, Zlib::MAX_WBITS, Zlib::MAX_MEM_LEVEL, Zlib::RLE)
            zstrm = z.deflate(scanlines.join(''), Zlib::FINISH)
            z.close
            idats = []
            zstrm.bytes.each_slice(idat_size) do |dstrm|
                idats << Chunk.new(type: "IDAT", data: dstrm)
            end
            
            idats


            # make a d2 array of rows
            # make "scanlines" on each row, the pixel bits starting at the far left and moving to the right. 
            # pack pixels togther, but pixels smaller than a byte never cross byte boundaries
            # when pixels have fewer than 8 bits and the scanline width is not evenly divisible by the nubmer of px/byte, the lowe-order bits are wated.
            # 1 filter type byte added to the beginning of each scanline

            #then zlib


        end 

        def self.IEND
            Chunk.new(type: "IEND", data: nil)
        end
       

        attr_reader :length, :type

        def initialize(type: ,data:)
            raise ArgumentError.new("Type must be a string, symbol, or an array") if !type.is_a?(String) && !type.is_a?(Symbol) && !type.is_a?(Array)
            @data = data.nil? ? [] : data
            @length = self.class.to_bytelen(4, DatX.int2buf(@data.length))
            self.class.test_length(@data.length)
            # binding.pry
            if type.is_a?(String) || type.is_a?(Symbol)
                @type = type.to_s.bytes
            else
                @type = type
            end

            
            @crc = crc
        end

        def data
            @length + @type + @data + @crc
        end

        def bytes
            data.pack("C*")
        end 

        private

        def self.crc_table_computed
            @@crc_table.length > 0
        end

        def self.make_crc_table
            for n in 0...256
                c = n
                for k in 0...8
                    if c.odd? 
                        c = 3988292384 ^ (c >> 1)
                    else
                        c = c >> 1
                    end
                end
                @@crc_table[n] = c
            end
        end 

        def self.test_length(num, limit: 2 ** 31 - 1)
            raise ArgumentError.new("Length cannot exceed 2^31 - 1") if num > limit
        end


        def crc
            c = ([255] * 4).pack("C4").unpack("L").first
            buff = @type + @data
            self.class.make_crc_table if !self.class.crc_table_computed
            for n in 0...buff.length
                c = @@crc_table[(c ^ buff[n]) & 255] ^ (c >> 8)
            end
            DatX.int2buf(c ^ DatX.buf2int([255] * 4))
        end

        def self.to_bytelen(len, byte_arr)
            diff = len - byte_arr.length
            if diff < 0
                byte_arr[0...diff]
            else
                byte_arr = ([0] * diff) + byte_arr
                byte_arr
            end
        end

    end

end