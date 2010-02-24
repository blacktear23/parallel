$:.unshift(File.dirname(__FILE__) + '/../lib')
 
require 'rubygems'
require 'spec'
require 'parallel'

def measure
  t_start = Time.now
  yield
  t_end = Time.now
  return t_end - t_start
end