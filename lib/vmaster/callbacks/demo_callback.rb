#
# Demo callback
#

callback :demo do
  option :demo, nil, 'Value to print'

  after :create do |options, server|
    puts "Hello world"
  end

  after :shutdown do 
    puts "That's all folks!"
  end
end

