require 'terminal-table'


command :create do |c|
  c.description = "Launch new server instance"
  c.option '--image TEMPLATE', String, 'instance template to use'
  c.option '--profile PROFILE', String, 'instance hardware profile'
  c.option '--wait', 'wait for instance to become operational'
  c.action do |args, options|
    name = args.shift || abort('Server name required')

    # verify server name
    abort("Virtual server with name #{name} already exists!") if VirtualMaster::Helpers.get_instance(name)

    # image 
    image_name = nil
    image_id = VirtualMaster::CLI.config[:default_image] || VirtualHost::DEFAULT_IMAGE

    if options.image
      image_name = options.image

      if image_name.match /^id:/
        # use image_id directly
        image_id = image_name[3..-1].to_i

        image_name = nil
      else
        # lookup predefined images
        image_id = VirtualMaster::IMAGES[image_name.to_sym]

        abort "Image '#{image_name}' not recognized!" unless image_id
      end
    end

    say image_name ? "Using image '#{image_name}' with ID #{image_id}" : "Using image with ID #{image_id}"

    # instance hardware profile
    profile_name = options.profile || VirtualMaster::DEFAULT_PROFILE

    profile = VirtualMaster::PROFILES[profile_name.to_sym]
    abort "Image name '#{options.profile}' not recognized!" unless profile

    hwp = VirtualMaster::Helpers.get_hw_profile(profile[:memory], profile[:storage])
    abort "Internal error: hardware profile not available" unless hwp

    say "Creating '#{profile_name}' instance (#{profile[:memory]} MB memory/#{profile[:storage]/1024} GB storage)"

    instance = VirtualMaster::Helpers.create_instance(name, image_id, hwp.id)

    # TODO handle exceptions (invalid image/profile, limits, etc.)

    say "Instance launch request accepted. Instance ID #{instance.id}"

    # FIXME authentication is missrepresented within Ruby object
    say "\n"
    say "Default password '#{instance.authentication[:username]}'"
      
    if options.wait
      print 'Waiting for instance'

      while (instance = VirtualMaster::Helpers.get_instance(name)).state != "RUNNING" do
        print '.'

        sleep(5)
      end

      puts
      puts "Instance ready!"
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

      instances << [instance.name, instance.state, ip_address]
    end

    abort "No instances found" if instances.empty?

    table = Terminal::Table.new :headings => ['name','state','ip_address'], :rows => instances
    puts table
  end
end

def instance_action(action, args)
  name = args.shift || abort('server name required')

  instance = VirtualMaster::Helpers.get_instance(name)
  instance.send("#{action}!")
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

    c.action do |args, options|
      instance_action(c.name, args)
    end
  end
end
