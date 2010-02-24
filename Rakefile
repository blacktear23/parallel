task :spec do
  sh 'spec spec'
end

task :gem do
  sh 'gem build *.gemspec'
end

task :pkg => :gem
task :package => :gem