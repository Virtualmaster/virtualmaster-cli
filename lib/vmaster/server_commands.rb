require 'terminal-table'

default_command :help

def get_instances
  api = VirtualMaster::CLI.api

  api.instances
end

def find_instance(instances, name)
  instances.each do |instance|
    return instance if instance.name == name
  end

  nil
end

command :list do |c|
  c.description = "List all running servers"
  c.action do |args, options|
    instances = []

    get_instances.each do |instance|
      instances << [instance.name, instance.state, instance.public_addresses.first[:address]]
    end

    table = Terminal::Table.new :headings => ['name','state','ip_address'], :rows => instances

    puts table
  end
end

def instance_action(action, args)
  name = args.shift || abort('server name required')

  instance = find_instance(get_instances, name)
  instance.send("#{action}!")
end

%w{start reboot stop shutdown}.each do |cmd|
  command cmd do |c|
    c.syntax = "virtualmaster stop SERVER"
    c.description = "Stop server"
    c.action do |args, options|
      instance_action(c.name, args)
    end
  end
end

# TODO continue
