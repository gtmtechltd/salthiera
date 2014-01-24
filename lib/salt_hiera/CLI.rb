require 'salt_hiera/salt_hiera'

module SaltHiera
class CLI

  def self.help
    puts "Usage: salthiera [ -c configfile ] key1=value1 key2=value2 key3=value3 ..."
    puts "  -c : specify a configfile to use"
    exit 0
  end

  def self.parse

    params = {}
    config_file = "/etc/salthiera.yaml"

    while arg = ARGV.shift do
      case arg
      when "--help"
        self.help
      when "-c"
        config_file = ARGV.shift
      else
        key, value = arg.split("=", 2)
        if value
          params[key] = value
        else
          self.help
        end
      end
    end

    @@opts = { :config => config_file, :params => params }

  end

  def self.execute

    salthiera = SaltHiera.new :config_file => @@opts[:config], :params => @@opts[:params]
    puts salthiera.to_yaml

  end

end
end