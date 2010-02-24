#:main: README
#

require 'rubygems'
require 'thread'

class Parallel
  @@config = {}
  @@config[:threads] = :cores
  
  # Config Parallel set how many thread will be created when iterate.
  # :threads parameter should bigger than 1 or set as :cores
  #
  # Parallel.config(:threads => 3)      # 3 thread will be created
  # Parallel.config(:threads => :cores)  # number of cpu core thread will be created
  #
  # Default is :core
  #
  def self.config(args = {})
    if args[:threads]
      if args[:threads] == :cores
        @@config[:threads] = args[:threads]
        return
      end
      num_threads = args[:threads].to_i
      if num_threads >= 1
        @@config[:threads] = num_threads
        return
      end
    end
    raise ArgumentError, 'Invalid argument'
  end
  
  # Itreate elements of array in concurrent and then return origin array.
  #
  # Parallel.for([1,2,3]) do |item|
  #   # do some expensive calculation
  # end
  #
  # NOTE:
  # Make sure lock is handled by your self.
  #
  def self.for(array)
    Parallel.map(array) {|v| yield v }
    array
  end
  
  # Itreate elements of array in concurrent and then return a new array that 
  # each element is returned by block.
  #
  # ret = Parallel.for([1,2,3]) do |item|
  #   item + 1
  # end
  # # ret => [2,3,4]
  #
  # NOTE:
  # Make sure lock is handled by your self.
  #
  def self.map(array)
    threads = []
    current = -1
    out = []
    
    Parallel.num_thread.times do |i|
      threads[i] = Thread.new do
        loop do
          index = Thread.exclusive{ current += 1 }
          break if index >= array.size
          out[index] = yield array[index]
        end
      end
    end
    
    threads.each{|t| t.join }
    out
  end
  
  class << self
    alias :each :for
  end
  
  private
  def self.num_thread
    return Parallel.get_cpu_core if @@config[:threads] == :cores
    @@config[:threads].to_i
  end
  
  def self.get_cpu_core
    case RUBY_PLATFORM
    when /darwin/
      `hwprefs cpu_count`.to_i
    when /linux/
      `cat /proc/cpuinfo | grep processor | wc -l`.to_i
    when /solaris/
      `psrinfo | grep on-line | wc -l`.to_i
    else
      2
    end
  end
end