Gem::Specification.new do |s|
  s.name     = "parallel"
  s.version  = "0.1.0"
  s.date     = "2010-2-16"
  s.summary  = "Parallel iterator"
  s.email    = "rain@joyent.com"
  s.homepage = "http://www.joyent.com.cn"
  s.description = "A parallel iterator for concurrent iteration."
  s.authors  = ["Rain Li"]

  s.has_rdoc = true
  s.rdoc_options = ["--main", "README"]
  s.extra_rdoc_files = ["README"]

  s.files = %w[
    README
    parallel.gemspec
    Rakefile
    lib/parallel.rb
    spec/parallel_for_spec.rb
    spec/parallel_map_spec.rb
    spec/spec_helper.rb
  ]
  s.add_dependency 'fastthread', '>= 1.0.7'
end