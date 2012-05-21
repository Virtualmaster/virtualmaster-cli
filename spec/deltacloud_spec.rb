require 'spec_helper'
require 'deltacloud'
require 'vmaster/helpers'

describe "DeltaCloud API integration" do
  it "should return HTTP 401 when called without valid credentials" do
    lambda {
      DeltaCloud.new(nil,nil, VirtualMaster::DEFAULT_URL)
    }.should raise_error(DeltaCloud::API::BackendError, "401 : Not authorized / Invalid credentials")
  end
end
