require 'spec_helper'

describe 'Parallel for test' do
  it 'number thread should return user defined' do
    Parallel.config(:threads => 3)
    Parallel.num_thread.should == 3
    Parallel.config(:threads => :cores)
    Parallel.num_thread.should == 2
    Parallel.config(:threads => "2")
    Parallel.num_thread.should == 2
    Parallel.config(:threads => 1)
    Parallel.num_thread.should == 1
  end
  
  it 'should throw an exception when user pass a not number parameter to config method' do
    lambda { Parallel.config(:threads => 's') }.should raise_exception
  end
  
  it 'should throw an exception when user pass less than 1 to config method' do
    lambda { Parallel.config(:threads => 0) }.should raise_exception
    lambda { Parallel.config(:threads => 0.5) }.should raise_exception
    lambda { Parallel.config(:threads => -1) }.should raise_exception
    lambda { Parallel.config(:threads => "-1") }.should raise_exception
  end
  
  it 'should floor a float parameter passed to config method' do
    Parallel.config(:threads => 1.5)
    Parallel.num_thread.should == 1
  end
  
  it 'should iterate all element in array that pass into for method' do
    Parallel.config(:threads => :cores)
    out = ''
    array = [1, 1, 1]
    Parallel.for(array) {|v| out += v.to_s}
    out.should == '111'
  end
  
  it 'should return an array that pass into it' do
    Parallel.config(:threads => :cores)
    array = [1, 2, 3]
    ret = Parallel.for(array) {|v| v}
    ret.should equal(array)
    ret.should_not equal([1, 2, 3])
  end
  
  it 'should faster than normal each' do
    Parallel.config(:threads => :cores)
    time = measure do
      Parallel.for([1, 2, 3]) {|v| sleep 1}
    end
    time.should <= 3
  end
  
  it 'should create 2 threads that we defined' do
    Parallel.config(:threads => 2)
    thread_count = {}
    Parallel.for([1, 2, 3, 4]) do |v| 
      thread_count[Thread.current] = 1
      sleep(0.5)
    end
    thread_count.keys.size.should == 2
  end
  
  it 'should work when user pass an empty array' do
    message = "It's fine"
    Parallel.config(:threads => :cores)
    Parallel.for([]) do |v|
      message = "should not run here"
    end
    message.should == "It's fine"
  end
  
  it 'should work with alias method each' do
    Parallel.config(:threads => :cores)
    out = ''
    array = [1, 1, 1]
    Parallel.each(array) {|v| out += v.to_s}
    out.should == '111'
  end
  
end