#
# Demo callback
#

callback :demo do
  after :create do |server|
    puts "Hello world!"
  end

  after :shutdown do 
    puts "That's all folks!"
  end
end

