class DatX


    def self.str2digest(str)
        str.bytes.map do |b| 
            hd = hexdigest(b)
            hd.length.odd? ? "0#{hd}" : hd
        end.join('')
    end

    # def self.str2hex(str)
    #     hex(str2digest(str))
    # end

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

    

end