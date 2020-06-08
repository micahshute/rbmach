class Rbmach::PNGStrategy

    # "\x89PNG\r\n\u001A\n\u0000\u0000\u0000\rIHDR\u0000\u0000\u0006\x89\u0000\u0000\u0003\xC8\b\u0002\u0000\u0000\u0000\x8A\u001F\x85\x89\u0000\u0000,\x93zTXtRaw profile type exif\u0000\u0000xڭ\x9Cir\\9\x92\xAD\xFFc\u0015\xB5\u0004\xCC\xC3r\u00008`\xF6v\xD0\xCB\xEF\xEF HeRʲ\xEE\xB2גI\xA2\x82\u0011\xF7bp?\x83\xC3/\xDD\xF9\xAF\xFFwݿ\xFE\xF5\xAF\xE0s\xAC.\x97\xD6\xEB\xA8\xD5\xF3+\x8F<\xE2\xE4\x8B\xEE?\xBF\xF6\xFB\x9B7\xBE\xBF߯>|\xFDz\xF5\xC7\xEBnw\x9F\xDEW\x91\x97\xF4\xD5\xE7\u007F~\x9C\xAF\x8B]^\x8F\xFC[>\xFF\x9D\xD9\u007F]\xE7\xEB\xF5\xAF\x9B\xBA9\xBF\xBE\xF1}\xA1\xAF;|\xFF\e&_\x95\xBF\xFE\xBF\xE2\xD7\xEB\xEB\xE7\xEBn}](\xF6\xDF.\xF4\xF5\x81\u0014\xBE\xEEl_\xB3\xFD~=~^\u000F_#t_\xDF\xF7u\xF4\xF6\xF79\x9F\xAF7\x94\xFD5\xD9\xFEן\x92\xF2ͧ\x8C\xAFu\xDD9\xE5⢥V\xB8r\xEE?\xA7\xF4\xC7\xFF\e\u001F\xB1\xC2 R\x8C'\x85\xE4\xDF\xDF\xF93\xBA\xE4\x9D\xFEJ\x93?\xE1\xF3w\xD4W\xFA\xBA\xA4\xC6\xDF1q\xDF\xC8Z\x8C\xD9\xE3\xDF\xD7d\xD6\xCF\xE4\x87}^w\xBF\xBEq>߈\xB1\xF7\u007FZ\xF4\xD8~\xBE~\xF3\xE7\xAB\xE4?\xAF\xBB?\u0016W\u0017\xCA\u007F~\x80{{\xDF4ǯ\xF7iB\x89+\xBC!s\xA1\xEFU__Ce\xF5\xFC\xDFwcϯ\xD7È~\xFEu\u0003\xFB\x9A\x81\x8F\xE3\xE7\xD4\xCE\xF7\x85\xD2\xCF\u000F\x9C\xF3\xEB\u0006?^\xBF\xDF\xEF/\xBF]\xE8~\u007F\xA0\u{4DFEF}\xD1WD\x93\e?_\xFF\xFE5>\xAF\xFF\xBAЯ\xEF\xCF\xF1cwȬ\xF4\u001D\xE2\xFF\xB4\t^ə\xFFv!\xFB,%o\xFE|\xE3\x8F\xD7\xCF\xFCy\x83\xF3u\x83;\u007FN-|\xDD9\xF8\xF9s\n\xE9\xD7Pӻ\xE4\uFBC7\xCF\xEB\u0006\xF2\xFB\x9F\xD6\"\xFE\xF6\xFA\xAF\v~^w\u007F| \xF3\x8D\xBFM!|O\xA1\xFC\xBCP\xF8\x95\xA4\xFF\xEEB\xFDߌh\xFC\x9B\xD7翹P\x8A_#\xFA\n\xC8\xF8\xB5vI#U\xA0~\x85C\xAE\u007F\xADރ\x91\xEF\v\xA5\xFD=\xA2\x9Fk\xF0\x92:\xBC\u0004\xF6\xA4\x84\xFE\u001E/\xB13_\xE7\x97\xDE!i\xD7\xFE\xB7o\xDC+\x86\xF2\"#G\xE0\xD7\u007F!\xF7_\bYs\xFC\u001E\xCB\xFC9\xF7\xBF\x96\xFF\xEF\u001F\x89\xF1\xEB\xA3_߯\xADvb5\xBB\xEF\xB9|\xBF\xF0\xFD\xFF\xDFwy\xFEv\x83r~^\xD0\xC5\xFE\xF

    REQUIRED_CHUNKS = [
        :IHDR,
        :IDAT,
        :IEND
    ]

    def initialize(pixels: nil, type: nil)
        @signature = [137, 80, 78, 71, 13, 10, 26, 10]
        @chunks = [Chunk.IHDR]

    end

    def bitstream
        all_data.map(&:chr).join''
    end

    private

    def all_data 
        @signature + @chunks.map(&:data).flatten 
    end
   


    class Chunk

        @@crc_table = {}

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

            wbytes = to_bytelen(4, width)

            hbytes = to_bytelen(4, height)
            bdbyte = [bit_depth]
            cmbyte = [compression_method]
            fmbyte = [filter_method]
            ilmbyte = [interlace_method]
            data = wbytes + hbytes + bdbyte + cmdbyte + fmbyte + ilmbyte
            Chunk.new(type: "IHDR", data: data) 
        end

        def self.IDAT()

        end

        def initialize(type: ,data:)
            raise ArgumentError.new("Type must be a string, symbol, or an array") if !type.is_a?(String) && !type.is_a?(Symbol) && !type.is_a?(Array)

            @length = [data.length]
            self.class.test_length(length)
            
            if @type.is_a?(String) || type.is_a?(Symbol)
                @type = type.to_s.bytes
            else
                @type = type
            end

            @data = data
            @crc = crc
        end

        def data
            @length + @type + @data + @crc
        end

        private

        def self.crc_table_computed
            crc.length > 0
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

        def self.test_length(num, limit: 2 * 31 - 1)
            raise ArgumentError.new("Length cannot exceed 2^31 - 1") if num > limit
        end

        # def update_crc(crc, )

        def crc
            "TODO: Make this work".bytes
        end

        def to_bytelen(len, byte_arr)
            diff = len - byte_arr.length
            if diff < 0
                byte_arr[0...diff]
            else
                diff.times do 
                    byte_arr = [0] + byte_arr
                end
                byte_arr
            end
        end

    end

end