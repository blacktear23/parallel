require 'spec_helper'

describe 'Test parallel map' do
  
  it 'should return a new array that each element plus one' do
    Parallel.config(:threads => :cores)
    ret = Parallel.map([1, 2, 3]) {|v| v + 1}
    ret.should eql([2, 3, 4])
  end  
  
end