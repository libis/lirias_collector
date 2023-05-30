
module Collector
  class ConfigFile < DataCollector::ConfigFile
    @config = {}
    @config_file = 'conf.yml'
    @config_file_path = ''

    def self.file
      @config_file
    end

    def self.file=(config_file)
      @config_file = config_file
    end

    private_class_method def self.init
      discover_config_file_path
      if @config.empty?
        config = YAML::load_file("#{path}/#{file}")
        @config = process(config)
      end
    end

    private_class_method def self.discover_config_file_path
      if @config_file_path.nil? || @config_file_path.empty?
        if File.exist?(file)
            @config_file_path = '.'
        elsif File.exist?("config/#{file}")
            @config_file_path = 'config'
        end
      end
    end
  end
end
