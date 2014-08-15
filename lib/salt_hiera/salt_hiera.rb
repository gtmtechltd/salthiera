require 'yaml'
require 'salt_hiera/logger'
require 'salt_hiera/configuration'
require 'salt_hiera/plugins/no_plugin'

module SaltHiera
class SaltHiera

  VERSION="0.3.2"

  def initialize attributes
    raise "Config error (#{params})" unless attributes[:config_file]
    raise "Config file (#{attributes[:config_file]}) doesn't exist" unless File.file? attributes[:config_file]

    file_contents = File.read(attributes[:config_file])
    begin
      @config = YAML::load(file_contents)
    rescue
      raise "Problem reading from config file #{attributes[:config_file]} (invalid YAML/permissions?)"
    end

    @config.each do |k, v|
      Configuration.set k, v
    end

    Logger.logfile(@config[:logfile])
    Logger.loglevel(@config[:loglevel])
    @params = attributes[:params]
    
  end

  def find_plugin plugin_name
    begin
      require "salt_hiera/plugins/#{plugin_name.downcase}"
    rescue
      Logger.critical "No plugin named #{plugin_name} exists"
      return Module.const_get("SaltHiera").const_get("Plugins").const_get("NoPlugin")
    end
    plugin_class = plugin_name.downcase.split("_").collect {|word| word.capitalize }.join("_")
    plugin = Module.const_get("SaltHiera").const_get("Plugins").const_get(plugin_class)
    raise "Could not find plugin #{plugin_name}" if plugin.nil?
    plugin
  end

  def to_yaml

    Logger.debug @config

    if @config["basedir"]
      Logger.debug "Setting basedir to \"#{@config['basedir']}\""
      Dir.chdir @config["basedir"]
    end

    results = {}

    @config.keys.each do |key|
      if @config[key].class == String
        @config[key].gsub!(/\%\{(.*?)\}/) {|exp| @params[exp[2..-2]] || "!NOT_DEFINED!" }   # Detokenize
      end
    end

    @config["hierarchy"].reverse.each do |hierarchy|
      Logger.debug "Analysing hierarchy element: #{hierarchy}"
      hierarchy_type, hierarchy_glob = hierarchy.split(':', 2)
      Logger.debug "    type: #{hierarchy_type}"
      Logger.debug "    glob: #{hierarchy_glob}"
      hierarchy_glob.gsub!(/\%\{(.*?)\}/) {|exp| @params[exp[2..-2]] || "!NOT_DEFINED!" }   # Detokenize
      Logger.debug "  reglob: #{hierarchy_glob}"
      next if hierarchy_glob.include? "!NOT_DEFINED!"
      files = Dir.glob(hierarchy_glob).collect {|x| x if File.file?(x) }.compact
      files.each do |file|
        Logger.debug "    file: #{file} (#{hierarchy_type})"
        plugin = find_plugin hierarchy_type
        dict = plugin.process_file file
        debug_dict "", dict
        results.merge! dict
      end
    end if @config["hierarchy"]
    results.to_yaml
  end

  def debug_dict prefix, dict
    dict.each do |k, v|
      Logger.debug " -------> Found #{prefix}#{k}"
      if v.class == Hash
        debug_dict "#{prefix}#{k}.", v
      end
    end
  end

end
end
