require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'open3'

RSpec::Core::RakeTask.new(:spec)

#task :default => :spec
task :default do
  system 'rake -T'
end

desc "open github origin url"
task :open_github do
  out, err, status = Open3.capture3("git remote -v")
  url = "https://"+out.match(/^origin\s+git@(.+) \(fetch\)/)[1].gsub(':','/')
  system "open #{url}"
end
