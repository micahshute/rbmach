RSpec.describe Rbmach::PCA do 


  it "can reduce the dimensionality of MNIST data and maintain the appropriate level of error" do
    train = File.read('./data/train-images-idx3-ubyte')
    
    train_bytes = train.bytes
    all_images = []
    curr_byte = 16
    100.times do |pic|
      all_images << train_bytes[curr_byte...(curr_byte + 784)]
      curr_byte = curr_byte + 784 + 16
    end
    ipm = Matrix[*all_images]
    pixel_matrix = ipm.transpose
    pca = Rbmach::PCA.new(pixel_matrix)
    red500 = pca.reduce(500)
    red300 = pca.reduce(300)
    red100 = pca.reduce(100)
    red50 = pca.reduce(50)
    red10 = pca.reduce(10)
    red5 = pca.reduce(5)
    red2 = pca.reduce(2)
    puts red500.row_size
    puts red500.column_size
    rest500 = pca.restore(red500)
    rest300 = pca.restore(red300)
    rest100 = pca.restore(red100)
    rest50 = pca.restore(red50)
    rest10 = pca.restore(red10)
    rest5 = pca.restore(red5)
    rest2 = pca.restore(red2)
    err500 = (pixel_matrix - rest500).sum.abs
    err300 = (pixel_matrix - rest300).sum.abs
    err100 = (pixel_matrix - rest100).sum.abs
    err50 = (pixel_matrix - rest50).sum.abs
    err10 = (pixel_matrix - rest10).sum.abs
    err5 = (pixel_maatrix - rest5).sum.abs
    err1 = (pixel_matrix - rest1).sum.abs
    puts err500
    puts err300
    puts err100
    puts err50
    puts err10
    puts err5
    puts err2
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
      restored = pca.restore(reduced)
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
        restored = pca.restore(reduced)
        expect((restored - Matrix[*data]).sum.abs).to be < 0.00000001
        reduced_1 = pca.reduce(1)
        restored = pca.restore(reduced_1)
        restored_ans = Matrix[[2.9999999999999996, 3.4999999999999996, 3.4999999999999996, 4.5, 4.5, 5.0, 6.0, 6.5, 6.5, 7.5, 7.5, 8.0], [2.9999999999999996, 3.4999999999999996, 3.4999999999999996, 4.5, 4.5, 5.0, 6.0, 6.5, 6.5, 7.5, 7.5, 8.0]]
        expect(restored).to eq(restored_ans)
     end

  end

end

