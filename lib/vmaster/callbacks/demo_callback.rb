#
# Demo callback
#

callback :demo do
  option :demo, String, 'Value to print'

  after :create do |options, server|
    puts "Hello #{options[:demo]}"
  end

  after :shutdown do 
    puts "That's all folks!"
  end
end

