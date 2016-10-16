# Load DSL and set up stages
require 'capistrano/setup'
require 'capistrano/deploy'

# Include default deployment tasks

# require "capistrano/rvm"
# require "capistrano/bundler"
# require "capistrano/rails"

# Include tasks from other gems included in your Gemfile
#
# For documentation on these, see for example:
#
#   https://github.com/capistrano/rvm
#   https://github.com/capistrano/rbenv
#   https://github.com/capistrano/chruby
#   https://github.com/capistrano/bundler
#   https://github.com/capistrano/rails
#   https://github.com/capistrano/passenger
#

require 'capistrano/rvm'
require 'capistrano/rails'
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
#require 'capistrano/passenger'
require 'capistrano/sidekiq'
require 'whenever/capistrano'
require 'thinking_sphinx/capistrano'
require 'capistrano/rails/collection'
require 'capistrano3/unicorn'

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }