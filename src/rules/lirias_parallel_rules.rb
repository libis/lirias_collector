ConfigFile.path="config"

ConfigFile.config_file="config_parallel.yml"

require 'lirias_pre_pnx_rules.rb'            # collect_records
require 'lirias_pre_pnx/parsing_rules.rb'    # parse_record
require 'lirias_pre_pnx/writing_rules.rb'    # create_tar

begin
    collect_records()
end
