#
# Shell Provisioner
#

def copy_file(session, file, destination)
  session.open_channel do |channel|
    channel.exec("cat > #{destination}") do |channel, success|
      channel.on_data do |ch,data|
        puts data
      end

      open(file) { |f| channel.send_data(f.read) }
      channel.eof!
    end
  end
  session.loop
end

def run_command(session, command)
  session.open_channel do |channel|
    channel.on_data do |ch,data|
      puts data
    end

    channel.exec command
  end
  session.loop
end

callback :shell_provisioner do
  option :script, String, 'Setup virtual machine using provided script'

  before :create do |options|
    abort "Shell script doesn't exist (#{options[:script]})" unless File.exists?(options[:script])
  end

  after :create do |options, server|
    script = open(options[:script]) { |f| f.readlines}

    Net::SSH.start(server.public_addresses.first[:address], 'root', :password => options[:password]) do |ssh|
      destination_path = "/tmp/shell_provisioner.sh"

      copy_file(ssh, options[:script], "/tmp/shell_provisioner.sh")
      puts

      say "***** running shell provisioner ******"
      run_command(ssh, "sh /tmp/shell_provisioner.sh")
    end
  end
end
