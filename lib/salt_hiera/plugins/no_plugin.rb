module SaltHiera
  module Plugins
    class NoPlugin

      def self.process_file file

        Logger.debug "(missing plugin) NoPlugin called on #{file}"
        {}

      end

    end
  end
end
