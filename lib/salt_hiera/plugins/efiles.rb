require 'openssl'
require 'base64'
require 'salt_hiera/configuration'

module SaltHiera
  module Plugins
    class Efiles

      def self.process_file file

        key = file.split("/").last
        value = File.read file
        returnhash = { key => value }
        returnhash = self.recurse returnhash
        returnhash

      end

      def self.recurse obj
        if obj.is_a? Array
          obj.each.with_index do |element, index|
            obj[index] = self.recurse element
          end
        elsif obj.is_a? Hash
          obj.each do |k, v|
            obj[k] = self.recurse v
          end
        elsif obj.is_a? String
          obj = obj.gsub(/ENC\[PKCS7,(.*?)\]/) {|x| self.decrypt($1) }
        else
          obj
        end
      end

      def self.decrypt cipherbinary

        public_key = Configuration.get "eyaml_public_key"
        private_key = Configuration.get "eyaml_private_key"

        raise StandardError, "pkcs7_public_key is not defined" unless public_key
        raise StandardError, "pkcs7_private_key is not defined" unless private_key

        private_key_pem = File.read private_key

        private_key_rsa = OpenSSL::PKey::RSA.new( private_key_pem )

        public_key_pem = File.read public_key

        public_key_x509 = OpenSSL::X509::Certificate.new( public_key_pem )

        ciphertext = Base64.decode64(cipherbinary)
        pkcs7 = OpenSSL::PKCS7.new( ciphertext )

        pkcs7.decrypt(private_key_rsa, public_key_x509)

      end

    end
  end
end
