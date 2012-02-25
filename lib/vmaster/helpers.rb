module VirtualMaster

  CONFIG_FILE = ".virtualmaster"
  DEFAULT_URL = "https://www.virtualmaster.cz/services/deltacloud"

  module Helpers
    def get_instances(api = VirtualMaster::CLI.api)
      api.instances
    end
  end
end
