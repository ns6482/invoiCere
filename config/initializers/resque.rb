require 'resque'
require 'resque_scheduler'

# make sure the RAILS_ENV variable is set so the
# resque-scheduler can load our scheduled jobs
ENV['RAILS_ENV'] = Rails.env

Resque.schedule = YAML.load_file("#{Rails.root}/config/resque_schedule.yml")