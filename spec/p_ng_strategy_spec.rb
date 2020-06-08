RSpec.describe Rbmach::PNGStrategy do 

  it "does something useful" do
    expect(false).to eq(true)
  end

  it 'correctly generates the PNG signature' do 
    png = RBmach::PNGStrategy.new
    png.bytes.take(8).to eq([137, 80, 78, 71, 13, 10, 26, 10])
  end

  it 'correclty generates the IHDR chunk' do 
    expect(false).to eq(true)
  end

  


end

