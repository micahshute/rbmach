##
# Class for initializing random numbers in a range or in a matrix

class Rbmach::RandomInitializationStrategy

    def self.random_matrix(rows: ,cols: , rng:)
        two_d_arr = Array.new(rows, nil)
        for rownum in 0...rows
            two_d_arr[rownum] = random_array(size: cols, rng: rng)
        end
        Matrix[*two_d_arr]
    end

    def self.random_array(size: ,rng:)
        a = Array.new(size, nil)
        for i in 0...size
            a[i] = random_weight(rng)
        end
        a
    end

    def self.random_weight(rng)
        r = rand - 0.5
        span = rng.last - rng.first
        mean = rng.sum / (span.to_f + 1)
        r * span + mean
    end
end