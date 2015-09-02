require 'spec_helper'
require 'deltacloud/client'
require 'vmaster/helpers'

describe "DeltaCloud API integration" do
  it "should return HTTP 401 when called without valid credentials" do
    lambda {
      Deltacloud::Client(VirtualMaster::DEFAULT_URL, nil,nil)
    }.should raise_error(Deltacloud::Client::BackendError, "401 : Not authorized / Invalid credentials")
  end
end
