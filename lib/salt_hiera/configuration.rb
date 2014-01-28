module SaltHiera
  class Configuration

    def self.set key, value
      @@confighash ||= {}
      @@confighash[key] = value
    end

    def self.get key
      @@confighash ||= {}
      @@confighash[key]
    end

  end
end
