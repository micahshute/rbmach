RSpec.describe Rbmach::GradientDescent do

  let(:lindata) do 
    x = Digiproc::Functions.linspace(1,20,1000)
    noise = Digiproc::Probability.nrand(1000)
    bias = 10
    weight = 0.5
    y = x.map.with_index{|v,i| bias + (noise[i] + v) * weight}  
    {x: x, y: y}
  end

  let(:cubic_data) do 
    x = Digiproc::Functions.linspace(-7,7,100)
    noise = Digiproc::Probability.nrand(100)
    bias = 5
    weights = [-2.3, 1.1, 7.4]
    y = x.map.with_index{|v,i| bias   + (v + noise[i] * 0.2) * weights[0] + ((v + noise[i] * 0.2) ** 2) * weights[1] + ((v + noise[i] * 0.2) ** 3) * weights[2]}
    {x: x, y: y}
  end

  let(:linweights) do 
    [10, 0.5]
  end

  let(:cubic_weights) do
    [5, -2.3, 1.1, 7.4] 
  end



  it "accepts a function, learning rate, convergence delta, and starting beta dimension" do
    gd = Rbmach::GradientDescent.new(vals: [[1,2,3], [4,5,6]], learning_rate: 0.0000000019, termination_type: :delta, termination_criteria: 0.00000001)
    expect(gd.vals).to eq(Matrix[[1,2,3], [4,5,6]])

  end

  it "randomizes beta if none is passed in" do 
    xdata = [0.2, 0.6, 1.9, 2.5, 4.0, 5.5]
    x = Matrix[[1] * xdata.length, xdata, xdata.map{|el| el ** 2}, xdata.map{|el| el ** 3}].transpose

    y = Matrix[[1.2, 4.2, 3.1, 5.0, 1.5, 2.9]].transpose
    gd = Rbmach::GradientDescent.new(dimensions: [4,1], learning_rate: 0.0000000019, termination_type: :delta, termination_criteria: 0.00000001)

    expect(gd.vals.class).to eq(Matrix)
    expect(gd.vals.row_count).to eq(4)
    expect(gd.vals.column_count).to eq(1) 

  end

  it "has a class function to generate random starting values" do 
    rvals = Rbmach::GradientDescent.random_matrix([5,5], 0..20)
    expect(rvals.class).to eq(Matrix)
    expect(rvals.column_count).to eq(5)
    expect(rvals.row_count).to eq(5)
    rvals.each do |val|
      expect(val).to be_between(0,20).inclusive
    end
  end

  it "starts beta with random starting values if no starting value is passed in" do 
  end

  it "allows a starting dimension to be passed in for beta value initialization" do 
  
  end

  it "can obtain a solution to a gradient descent linear regression problem within a certain margin" do 
    gd = Rbmach::GradientDescent.new(dimensions: [2,1], learning_rate: 0.00001, termination_type: :delta, termination_criteria: 0.00001)
    # Cost fn = ||XB - Y||^2
    # d(cost_fn) = xT * (xb - y)
    x = Matrix[lindata[:x]] 
    x = Matrix[[1] * lindata[:x].length].vstack(x)
    x = x.transpose
    y = Matrix[lindata[:y]].transpose
    beta_final = gd.descend do |b|
      x.transpose * (x * b - y)
    end
    tot_diff = 0
    b = beta_final.to_a.flatten
    for i in 0...b.length
      tot_diff += (b[i] - linweights[i]) ** 2
    end
    xans = lindata[:x]
    yans = lindata[:x].map do |val|
      b[0] + val * b[1]
    end
    # plt = Digiproc::Rbplot.line(lindata[:x],lindata[:y])
    # plt.size(2000,2000)
    # plt.title('Linear Gradient Descent')
    # plt.xlabel('x axis')
    # plt.ylabel('y axis')
    # plt.add_line(xans, yans)
    # plt.xsteps(7)
    # plt.theme(:dark)
    # plt.show
    expect(tot_diff).to be < 0.1
  end

  it 'can obtain a solution to an expanded (cubic) linear regression model with good resluts' do 
    gd = Rbmach::GradientDescent.new(dimensions: [4,1], learning_rate: 0.0000011, termination_type: :delta, termination_criteria: 0.00001)
    # Cost fn = ||XB - Y||^2
    # d(cost_fn) = xT * (xb - y)
    x = Matrix[cubic_data[:x], cubic_data[:x].map{|v| v ** 2}, cubic_data[:x].map{|v| v ** 3}] 
    x = Matrix[[1] * cubic_data[:x].length].vstack(x)
    x = x.transpose
    y = Matrix[cubic_data[:y]].transpose
    beta_final = gd.descend do |b|
      x.transpose * (x * b - y)
    end
    tot_diff = 0
    b = beta_final.to_a.flatten
    
    xans = cubic_data[:x]
    yans = cubic_data[:x].map do |val|
      b[0] + val * b[1] + (val ** 2) * b[2] + (val ** 3) * b[3]
    end
    ytest = cubic_data[:x].map{|el| cubic_weights[0] + cubic_weights[1] * el + cubic_weights[2] * el ** 2 + cubic_weights[3] * el ** 3}
    for i in 0...yans.length
     
      tot_diff += (ytest[i] - yans[i]) 
    end
    tot_diff /= ytest.length.to_f
    puts tot_diff
    # puts b.to_s
    # puts tot_diff
    # plt = Digiproc::Rbplot.line(cubic_data[:x],cubic_data[:y])
    # plt.size(2000,2000)
    # plt.title('Cubic Gradient Descent')
    # plt.xlabel('x axis')
    # plt.ylabel('y axis')
    # plt.add_line(xans, yans)
    # plt.xsteps(7)
    # plt.theme(:dark)
    # plt.show
    expect(tot_diff.abs).to be < 20
  end
end



