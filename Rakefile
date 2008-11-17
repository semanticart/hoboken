require 'spec/rake/spectask'

task :environment do
  ENVIRONMENT = 'development'
  require 'rubygems'
  require 'init'
end

desc "Run all specs"
task :spec do
  puts `ruby hoboken_spec.rb`
end

desc 'migrate the article table'
task :migrate => [:environment] do 
  Article.auto_migrate!
end