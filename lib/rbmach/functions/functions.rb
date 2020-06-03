class Rbmach::Functions

    def self.center_data(*arrs)
        mean_arr = []
        res = arrs.map do |arr|
            mean = arr.sum / arr.length.to_f
            mean_arr << mean
            arr.map{|el| el - mean}
        end
        if res.length == 1
            [res.first, mean_arr.first]
        else
            [res, mean_arr]
        end
    end


    def self.n_largest_eigenvalue_rows(d:, n:)
        max_eval = [-Float::INFINITY] * n
        max_rows = [nil] * n
        for i in 0...d.row_count 
            eval = d.row(i).find{|el| el != 0} || 0
            for j in 0...n
                if eval > max_eval[j]
                    for sh in (n-2).downto(j) 
                        max_eval[sh + 1] = max_eval[sh]
                        max_rows[sh + 1] = max_rows[sh]
                    end
                    max_eval[j], max_rows[j] = eval, i 
                    break
                end
            end
        end
        return max_rows
    end

end