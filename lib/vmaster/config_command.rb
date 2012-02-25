require 'yaml'


command :config do |c|
  c.description = "Configure VirtualMaster API username and password"

  c.option '--username NAME', String, 'API username'
  c.option '--password PASSWD', String, 'API password'

  c.action do |args, options|
    config_file = File.join(ENV['HOME'], VirtualMaster::CONFIG_FILE)
    if File.exists?(config_file)
      abort "Default configuration file already exists: #{config_file}"
    else
      say "Running virtualmaster for first time"
    end

    unless options.username && options.password
      say "\n"
      say "Your API credentials are available from http://www.virtualmaster.cz/en/api#settings"
      say "\n"
    end

    options.username = ask("Enter API username:") unless options.username
    options.password = password("Enter API password:", "*") unless options.password

    # verify and store credentials
    begin
      api = DeltaCloud.new(options.username, options.password, VirtualMaster::DEFAULT_URL)

      config = {
        'username' => options.username,
        'password' => options.password,
        'default_image' => VirtualMaster::DEFAULT_IMAGE
      }

      File.open(config_file, 'w') do |f|
        f.puts YAML.dump(config)
      end

      say "Setting stored under #{config_file}"
    rescue DeltaCloud::API::BackendError => e
      say "Unable to connect to VirtualMaster API: #{e.message}"
    rescue Exception => e
      say "Unable to configure environment: #{e.message}"
    end

  end
end
