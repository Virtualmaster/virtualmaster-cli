require 'spec_helper'

describe "VirtualMaster CLI" do
  before :each do
    @runner = Commander::Runner.instance
  end

  it "should have command :config" do
    @runner.commands.should have_key('config')
  end

  it "should have command server commands" do
    %w{create list start reboot stop shutdown destroy}.each do |cmd|
      @runner.commands.should have_key(cmd)
    end
  end
end
