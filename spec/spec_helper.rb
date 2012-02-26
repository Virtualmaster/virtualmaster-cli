$:.unshift File.dirname(__FILE__) + '/../lib'

require 'vmaster'

program :name, "virtualmaster"
program :version, VirtualMaster::VERSION
program :description, "VirtualMaster command line interface"
program :help_formatter, :compact

default_command :test

command :test do |c|
end
