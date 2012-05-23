$:.unshift File.dirname(__FILE__) + '/../lib'

if ENV['COVERAGE']
  require 'simplecov'
  require 'simplecov-rcov'

  SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter

  SimpleCov.start do
    add_filter '/vendor'
    add_filter '/spec'
  end
end

require 'vmaster'

# manually load commands
require 'vmaster/config_command'
require 'vmaster/server_commands'

program :name, "virtualmaster"
program :version, VirtualMaster::VERSION
program :description, "Virtualmaster command line interface"
program :help_formatter, :compact

default_command :test

command :test do |c|
end


