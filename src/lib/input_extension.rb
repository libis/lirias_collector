module InputExtension
    def initialize(logger = Logger.new(STDOUT))
        @logger = logger
        # super # <- as needed, invokes the original Collector::Input#initalize
    end
end

DataCollector::Input.prepend(InputExtension)