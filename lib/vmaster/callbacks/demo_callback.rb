#
# Demo callback
#

callback :demo do
  option :demo, nil, 'Value to print'

  after :create do |options, server|
    puts "Hello world"
  end

  after :shutdown do 
    puts "That's all for now"
  end

  after :reboot do
    puts "It's raining init 6"
  end

  before :destroy do
    puts "It's all going to shambles"
  end

end

