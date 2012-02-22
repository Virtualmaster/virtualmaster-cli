require 'yaml'
require 'deltacloud'

module VirtualMaster
  class CLI
    @@api = nil

    def self.run
      # load config
      config_file = File.join(ENV["HOME"], ".virtualmaster")
      if File.exists? config_file
        @config = YAML::load(File.open(config_file))

        @@api = DeltaCloud.new(@config["name"], @config["password"], @config["endpoint"])
      end

      yield
    end

    def self.api
      @@api
    end
  end
end
