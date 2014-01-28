# Simple logger - not designed to be particularly good, just basic

module SaltHiera
  class Logger
    @@loglevels = { :critical => 1,
                    :error => 2,
                    :warn => 3,
                    :info => 4,
                    :debug => 5,
                    :trace => 6 }

    def self.logfile filename
      @@logfile ||= filename
      @@loglevel ||= :info
      @@log ||= File.open(filename, "a") unless filename.nil?
    end

    def self.loglevel level
      @@loglevel = level if @@loglevels[level]
    end

    def self.critical msg
      self.raw :critical, msg
      raise msg
    end

    def self.error msg
      self.raw :error, msg
    end

    def self.warn msg
      self.raw :warn,  msg
    end

    def self.info msg
      self.raw :info, msg
    end

    def self.debug msg
      self.raw :debug, msg
    end

    def self.trace msg
      self.raw :trace, msg
    end

    def self.raw level, msg
      self.logfile "/tmp/salthiera.log"
#      if @@loglevels[level] && @@loglevels[level] > @@loglevels[@@loglevel] then
        @@log.write "[#{level.to_s}]: #{msg}\n"
        @@log.flush
#      end
    end

  end
end