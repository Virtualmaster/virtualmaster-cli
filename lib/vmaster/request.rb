require 'rest_client'

#
# Monkey-patch RestClient.request to include User Agent 
#
module RestClient
  class Request
    def default_headers
		  { :accept => '*/*; q=0.5, application/xml', :accept_encoding => 'gzip, deflate', "User-Agent" => "virtualmaster-cli/#{VirtualMaster::VERSION} #{RUBY_PLATFORM}" }
		end
  end
end