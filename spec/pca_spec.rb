RSpec.describe Rbmach::PCA do 


  it "can reduce the dimensionality of MNIST data and maintain the appropriate level of error" do
    expect(false).to eq(true)
  end

  describe "#choose_k" do 
    it "accepts an error rate" do 
      expect(false).to eq(true)
    end
    
    it "chooses a k value that keeps the error above some value" do 
      expect(false).to eq(true)
    end
  end


  describe "#reduce" do 

    it "correctly reduces the dimensionality of the data" do
      x = [3,3,4,4,5,5,6,6,7,7,8,8]
      y = [3,4,3,5,4,5,6,7,6,8,7,8]
      data = [x,y]
      pca = Rbmach::PCA.new(data)
      reduced = pca.reduce(1).to_a.first
      one_d_data = [-3.5355339059327378, -2.8284271247461903, -2.8284271247461903, -1.4142135623730951, -1.4142135623730951, -0.7071067811865476, 0.7071067811865476, 1.4142135623730951, 1.4142135623730951, 2.8284271247461903, 2.8284271247461903, 3.5355339059327378]
      expect(reduced).to eq(one_d_data)
    end

    it "does not lose data if the number of dimensions equals the original dimensions" do 
      x = [3,3,4,4,5,5,6,6,7,7,8,8]
      y = [3,4,3,5,4,5,6,7,6,8,7,8]
      data = [x,y]
      pca = Rbmach::PCA.new(data)
      reduced = pca.reduce(2)
      restored = pca.restore(reduced_data: reduced)
      expect((restored - Matrix[*data]).sum.abs).to be < 0.00000001
    end


  end

  describe "#restore" do

     it "restores an estimate of the original data" do 
        x = [3,3,4,4,5,5,6,6,7,7,8,8]
        y = [3,4,3,5,4,5,6,7,6,8,7,8]
        data = [x,y]
        pca = Rbmach::PCA.new(data)
        reduced = pca.reduce(2)
        restored = pca.restore(reduced_data: reduced)
        expect((restored - Matrix[*data]).sum.abs).to be < 0.00000001
        reduced_1 = pca.reduce(1)
        restored = pca.restore(reduced_data: reduced_1)
        restored_ans = Matrix[[2.9999999999999996, 3.4999999999999996, 3.4999999999999996, 4.5, 4.5, 5.0, 6.0, 6.5, 6.5, 7.5, 7.5, 8.0], [2.9999999999999996, 3.4999999999999996, 3.4999999999999996, 4.5, 4.5, 5.0, 6.0, 6.5, 6.5, 7.5, 7.5, 8.0]]
        expect(restored).to eq(restored_ans)
     end

  end

end

