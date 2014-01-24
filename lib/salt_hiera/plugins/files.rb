module SaltHiera
  module Plugins
    class Files

      def self.process_file file

        key = file.split("/").last
        value = File.read file
        { key => value }

      end

    end
  end
end
