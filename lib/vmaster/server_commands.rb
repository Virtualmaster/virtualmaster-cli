require 'terminal-table'
require 'net/ssh'
require 'logger'
require "base64"
require 'openssl'

log = Logger.new(STDOUT)
log.level = Logger::WARN

# SSH copy id
# FIXME how to select the right key

command :create do |c|
  c.description = "Launch new server instance"

  c.option '--image TEMPLATE', String, 'instance template to use'
  c.option '--profile PROFILE', String, 'instance hardware profile'
  c.option '--zone ZONE', String, 'Availability zone to launch instance i'
  c.option '--level LEVEL', String, 'Instance level to use (personal, production)'
  c.option '--detached', 'Do not wait for instance to become operational (disables callbacks)'

  # generate options for callbacks
  VirtualMaster::CLI.callbacks.each do |cb|
    c.send :option, *(cb.to_option)
  end

  c.action do |args, options|
    # default values
    options.default :zone => "prague-l1"
    options.default :level => "personal"
    options.default :interactive => true

    name = args.shift || abort('Server name required')

    # verify server name
    abort("Virtual server with name #{name} already exists!") if VirtualMaster::Helpers.get_instance(name)

    # support for non-interactive mode
    options.interactive = false if options.detached

    # image 
    image_name = nil
    image_id = VirtualMaster::CLI.config[:default_image] || VirtualHost::DEFAULT_IMAGE

    if options.image
      image_name = options.image

      if image_name.match /^[\d]+$/
        # use image_id directly
        image_id = image_name.to_i

        image_name = nil
      elsif image_name.match /^http(s)?:\/\//
        image_id = image_name
        image_name = nil
      else
        # lookup predefined images
        image_id = VirtualMaster::CLI.config[:images][image_name.to_sym]

        abort "Image '#{image_name}' not recognized!" unless image_id
      end
    end

    say image_name ? "Using image '#{image_name}' with ID #{image_id}" : "Using image #{image_id}"

    # instance hardware profile
    profile_name = options.profile || VirtualMaster::DEFAULT_PROFILE

    profile = VirtualMaster::CLI.config[:profiles][profile_name.to_sym]
    profile = VirtualMaster::PROFILES[profile_name.to_sym] unless profile

    abort "Image name '#{options.profile}' not recognized!" unless profile

    # before :create callbacks
    VirtualMaster::Callbacks.trigger_event(:create, :before, options.__hash__, nil)

    say "Creating '#{profile_name}' instance (#{profile[:memory]} MB memory/#{profile[:storage]/1024} GB storage)"

    realm = "#{options.zone}-#{options.level}"

    instance = VirtualMaster::Helpers.create_instance(name, image_id, profile, realm) 

    # TODO handle exceptions (invalid image/profile, limits, etc.)

    say "Instance launch request accepted. Instance ID #{instance.id}"

    # FIXME authentication is missrepresented within Ruby object
    password = instance.authentication[:username]
    puts
    say "Default password '#{password}'"
    puts

    options.password = password

    # copy-id implies waiting for instance to become operational
    if options.interactive
      print 'Waiting for instance'

      while (instance = VirtualMaster::Helpers.get_instance(name)).state != "RUNNING" do
        print '.'

        sleep(5)
      end

      puts
      puts "Instance ready."

      # TODO consistent naming (instance vs server)
      VirtualMaster::Callbacks.trigger_event(:create, :after, options.__hash__, instance)

      puts
      puts "Try to login using `ssh root@#{instance.public_addresses.first[:address]}'"      
    end
  end
end

command :list do |c|
  c.description = "List all running servers"
  c.action do |args, options|
    instances = []

    VirtualMaster::Helpers.get_instances.each do |instance|
      unless instance.public_addresses.first.nil?
        ip_address = instance.public_addresses.first[:address]
      else
        ip_address = "(not assigned)"
      end

      instances << [instance.name, instance.state, ip_address, instance.realm.id]
    end

    abort "No instances found" if instances.empty?

    table = Terminal::Table.new :headings => ['name','state','ip_address', 'zone'], :rows => instances
    puts table
  end
end

def instance_action(action, options, args)
  name = args.shift || abort('server name required')

  instance = VirtualMaster::Helpers.get_instance(name)

  abort "Invalid instance name!" if instance.nil?

  VirtualMaster::Callbacks.trigger_event(action.to_sym, :before, options.__hash__, instance)

  instance.send("#{action}!")

  VirtualMaster::Callbacks.trigger_event(action.to_sym, :after, options.__hash__, instance)

end

%w{start reboot stop shutdown destroy}.each do |cmd|
  command cmd do |c|
    c.syntax = "virtualmaster #{c.name} SERVER"

    case c.name
    when "start"
      c.description = "Start server (when stopped)"
    when "reboot"
      c.description = "Reboot server"
    when "stop"
      c.description = "Stop server"
    when "shutdown" 
      c.description = "Shutdown server (ACPI)"
    when "destroy"
      c.description = "Remove server"
    end

    # generate options for callbacks
    VirtualMaster::CLI.callbacks.each do |cb|
      c.send :option, *(cb.to_option)
    end

    c.action do |args, options|
      instance_action(c.name, options, args)
    end
  end
end
