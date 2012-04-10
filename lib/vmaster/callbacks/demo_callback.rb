#
# Demo callback
#

callback :demo do
  # TODO how to trigger callback
  # - default
  # - by switch
  # - pass options
  # - ability to display options using 'help'

  option :demo, String

  after :create do |server|
    puts "Hello world!"
  end

  after :shutdown do 
    puts "That's all folks!"
  end
end

