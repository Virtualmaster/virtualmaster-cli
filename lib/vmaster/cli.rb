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

        puts @config.inspect

        @@api = DeltaCloud.new(@config["username"], @config["password"], VirtualMaster::DEFAULT_URL)
      end

      yield
    end

    def self.api
      @@api
    end
  end
end
