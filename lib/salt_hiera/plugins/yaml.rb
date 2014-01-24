module SaltHiera
  module Plugins
    class Yaml

      def self.process_file file

        contents = File.read file
        dict = YAML.load contents
        dict

      end

    end
  end
end
