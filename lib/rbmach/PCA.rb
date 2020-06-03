class Rbmach::PCA

    attr_reader :dimensions, :data, :cov, :v, :d

    #data :: nxm array (or matrix) n = number of features (dimensions), m = number of observations
    def initialize(data)
        data, @means = Rbmach::Functions.center_data(*data)
        data = Matrix[*data] if !data.is_a?(Matrix)
        @data = data
        @dimensions = data.row_count
        @cov = (1.0 / @data.column_count) * (@data * @data.transpose)
        svd = @cov.eigen
        @v, @d = svd.v, svd.d
    end

    def reduce(dim)
        eigenvectors = n_largest_eigenvectors(dim)
        eigenvectors * @data
    end

    def choose_k(error:)

    end

    def restore(reduced_data:)
        reduced_data = Matrix[*reduced_data] if reduced_data.is_a? Array
        dimensions = reduced_data.row_count
        eigenvectors = n_largest_eigenvectors(dimensions)
        Matrix[*(eigenvectors.transpose * reduced_data).to_a.map.with_index do |row, i|
            row.map{|el| el + @means[i]}
        end]
    end

    private

    def n_largest_eigenvectors(n)
        largest_eigenvalue_rows = Rbmach::Functions.n_largest_eigenvalue_rows(n: n, d: @d)
        Matrix[*n.times.map { |i| @v.column(largest_eigenvalue_rows[i]) }]
    end

end