require "resque/tasks"
require 'resque_scheduler/tasks'


namespace :resque do
  puts "Loading Rails environment for Resque"
  task :setup => :environment do
    ActiveRecord::Base.descendants.each { |klass|  klass.columns }
  end
end