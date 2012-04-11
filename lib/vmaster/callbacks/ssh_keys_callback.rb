#
# SSH keys callback
# 

require 'net/ssh'
require 'base64'
require 'openssl'

callback :ssh_keys do
  option :identity, String, 'Identity file which is going to be copied to target machine'

  after :create do |options, server|
    authorized_key = nil

    abort "Specified identity file #{options[:identity]} doesn't exist!" unless File.exist?(options[:identity])

    say "Loading identity file #{options[:identity]}\n"
    key = OpenSSL::PKey::RSA.new File.read options[:identity]

    # build authorized key output string
    authtype = key.class.to_s.split('::').last.downcase
    b64pub = ::Base64.encode64(key.to_blob).strip.gsub(/[\r\n]/, '')
    authorized_key = "ssh-%s %s\n" % [authtype, b64pub]  # => ssh-rsa AAAAB3NzaC1...=

    Net::SSH.start(server.public_addresses.first[:address], 'root', :password => options[:password]) do |ssh|
      # TODO exception handling
      output = ssh.exec!("mkdir ~/.ssh")
      output = ssh.exec!("echo '#{authorized_key}' >>~/.ssh/authorized_keys")
    end
  end
end
