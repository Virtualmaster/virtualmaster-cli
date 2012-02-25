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

        @@api = DeltaCloud.new(@@config[:username], @@config[:password], VirtualMaster::DEFAULT_URL)
      end

      yield
    end

    def self.api
      @@api
    end

    def self.config
      @@config
    end
  end
end
