##
# Class to easily implement gradient descent
class Rbmach::GradientDescent


    TERMINATION_TYPES = [
        :epoch,
        :delta
    ]

    def self.random_matrix(dimensions, rng)
        Rbmach::RandomInitializationStrategy.random_matrix(rows: dimensions[0], cols: dimensions[1], rng: rng)
    end

    attr_reader :vals

    ##
    # == Input Args
    # vals (optional):: initial values of what needs to be optimized (default nil)
    # dimensions (optional):: required if vals are not present. creates random vector of initial vals (default nil)
    # learning rate (Numeric):: rate at which we change the vals in each iteration
    # termination type (symbol):: :epoc or :delta; should gradient descent terminate after a certain number of epochs or after the change in the derivative of the cost function decreases by a certain small number
    # epoch count (Numeric) :: if :epoch is selected, this is the number of epochs occur before termination
    # termination criteria (Numeric) :: the sum of all delta of the derivative of the vals in one iteration
    def initialize(vals: nil, dimensions: nil, learning_rate: ,termination_type: , epoch_count: nil, termination_criteria: nil)
        @termination_type = termination_type
        if vals
            if @vals.is_a?(Matrix)
                @vals = vals
            else
                @vals = twod?(vals) ? Matrix[*vals] : Matrix[vals]
            end
        else
            @vals = self.class.random_matrix(dimensions, 0..10)
        end
        @learning_rate = learning_rate
        @epoch_count, @termination_criteria = epoch_count, termination_criteria
    end

    # Method which performs the 
    def descend
        if @termination_type == :epoch
            epoch_count.times do 
                @vals = @vals - @learning_rate * yield(@vals)
            end
        else
            delta = Float::INFINITY
            while delta > @termination_criteria
                old_vals = @vals
                @vals = @vals - @learning_rate * yield(@vals)
                i = 0
                delta = @vals.reduce(0) do |mem, el|
                    row = i / @vals.column_count
                    col = i % @vals.column_count
                    i += 1
                    mem + (el - old_vals[row, col]).abs
                end
                # puts delta
            end
        end
        @vals
    end

    private

    def twod?(vals)
        return false if !vals.respond_to?(:length)
        return false if !vals.first.respond_to?(:length)
        true
    end

end