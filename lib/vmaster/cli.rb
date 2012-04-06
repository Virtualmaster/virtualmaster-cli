require 'yaml'
require 'deltacloud'

module VirtualMaster
  class CLI
    @@api = nil
    @@config = nil

    def self.run
      # load config
      config_file = File.join(ENV["HOME"], ".virtualmaster")
      if File.exists? config_file
        config = YAML::load(File.open(config_file))

        @@config = config.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}

        unless @@config[:profiles]
          puts "WARNING: Please, reconfigure virtualmaster-cli (delete your '~/.virtualmaster' and run `virtualmaster config` again). This way you can use custom instance profiles correctly (new in version 0.0.5)"
          puts
        end

        begin
          @@api = DeltaCloud.new(@@config[:username], @@config[:password], VirtualMaster::DEFAULT_URL)
        rescue DeltaCloud::API::BackendError => e
          abort "Invalid API response: #{e.message}"
        rescue Exception => e
          abort "Unable to connect to Virtualmaster's DeltaCloud API: #{e.message}" 
        end
      end

      yield
    end

    def self.api
      abort "No configuration available! Please run 'virtualmaster config' first!" unless @@api
      @@api
    end

    def self.config
      @@config
    end
  end
end
