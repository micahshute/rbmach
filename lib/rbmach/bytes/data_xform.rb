class DatX

    def self.pad(num: nil, len: , bytes: false)
        if bytes
            if num.is_a?(Array)
                overvlow = len - (num.length % len)
                return [0] * overflow + num
            elsif num.is_a?(Integer)
                pad(int2buf(num))
            elsif num.is_a?(String)
                pad(num.unpack("C*")).pack("C*")
            else
                ArguemntError.new("Num must be a Array, Integer, or ByteString")
            end
        else
            if num.is_a?(Numeric)
                bin_num = num.to_s(2)
            else
                bin_num = num
                overflow = len - (bin_num.length % len)
                padded = "0" * overflow + bin_num
                return padded
            end
        end
    end


    def self.str2digest(str)
        str.bytes.map do |b| 
            hexdigest(b)
        end.join('')
    end

    def self.str2hex(str)
        hex(str2digest(str))
    end

    def self.hex(input)

        if input.is_a?(Numeric)
            hex(hexdigest(input))
        elsif input.is_a?(String)
            hd = input.length.odd? ? "0#{input}" : input
            [hd].pack("H*")
        else
            raise ArgumentError.new("Input must be a string or number")
        end

    end

    def self.hexdigest(num)
        dig = num.to_s(16)
        dig.length.odd? ? "0#{dig}" : dig
    end

    def self.buf2digest(barr)
        barr.pack("C*").unpack("H*").first
    end

    def self.buf2hex(barr)
        barr.pack("C*")
    end

    def self.buf2int(barr)
        buf2digest(barr).to_i(16)
    end

    def self.int2buf(num)
        hex(num).bytes
    end

    def self.hex2int(hex)
        hex.unpack("H*").first.to_i(16)
    end
    

end