RSpec.describe Rbmach::Functions do 

  describe "#center_data" do
    it "accepts any number of arrays of values nad returns centered versions of those arrays" do
      xin = [3,3,4,4,5,5,6,6,7,7,8,8]
      yin = [3,4,3,5,4,5,6,7,6,8,7,8]
      data ,_ = Rbmach::Functions.center_data(xin, yin)
      x,y = data
      expect(x.sum / x.length.to_f).to eq(0)
      expect(y.sum / y.length.to_f).to eq(0)
      just_x, _ = Rbmach::Functions.center_data(xin)
      expect(just_x.sum / just_x.length.to_f).to eq(0)
    end

    it "also returns the mean of the data that it is centering" do
      expect(false).to eq(true)
    end

  end

  describe "#n_largest_eigenvalue_rows" do 

    it "accepts an eigenvalue matrix and chooses the n largest values" do 

      x = [-2.5, -2.5, -1.5, -1.5, -0.5, -0.5, 0.5, 0.5, 1.5, 1.5, 2.5, 2.5]
      y = [-2.5, -1.5, -2.5, -0.5, -1.5, -0.5, 0.5, 1.5, 0.5, 2.5, 1.5, 2.5]

      mx = Matrix[x]
      my = Matrix[y]
      X = Matrix.vstack(mx,my)
      xxt = X * X.transpose
      c = (1 / x.length.to_f) * xxt
      svd = c.eigen
      d = svd.d
      largest_eig = Rbmach::Functions.n_largest_eigenvalue_rows(n: 1, d: d)
      expect(largest_eig).to eq([1])
      largest_eig2 = Rbmach::Functions.n_largest_eigenvalue_rows(n: 2, d: d)
      expect(largest_eig2).to eq([1,0])
    end
  end
  

end

