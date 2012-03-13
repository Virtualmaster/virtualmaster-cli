module VirtualMaster

  CONFIG_FILE = ".virtualmaster"
  DEFAULT_URL = "https://www.virtualmaster.cz/services/deltacloud"

  DEFAULT_IMAGE = 842
  DEFAULT_PROFILE = "micro"

  # TODO use as a definition
  IMAGES = {
    :ubuntu_lucid => 124,
    :debian_squeeze => 842,
    :centos_55 => 135
  }

  PROFILES = {
    :nano => {
      :memory => 256,
      :storage => 3840
    },
    :micro => {
      :memory => 512,
      :storage => 6144
    },
    :milli => {
      :memory => 1024,
      :storage => 20480,
    },
    :small => {
      :memory => 2048,
      :storage => 30720
    },
    :medium => {
      :memory => 4096,
      :storage => 40960
    }
    #:large => {
    #  :memory => 8192,
    #  :storage => 8192
    #}
  }


  module Helpers
    def self.get_instances
      VirtualMaster::CLI.api.instances
    end

    def self.get_instance(name)
      get_instances.each do |instance|
        return instance if instance.name == name
      end

      nil
    end

    def self.get_hw_profile(memory, storage)
      api = VirtualMaster::CLI.api

      profile_list = api.hardware_profiles.reject { |p| p.memory.value.to_i != memory && p.storage.value.to_i != storage }

      profile_list.first
    end

    def self.create_instance(name, image_id, profile_id)
      api = VirtualMaster::CLI.api

      api.create_instance(image_id, :name => name, :hwp_id => profile_id)
    end
  end
end
