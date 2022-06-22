#Get last ran date

############################################################### TEST ADAPTATIONS #####################################
# Set the configuration path to test_config => will read ./test_config/config.yml
# Default is ./config.yml or config/config.yml
#ConfigFile.path="config"

ConfigFile.path="config"
ConfigFile.config_file="config_recent.yml"

require 'lirias_pre_pnx_rules.rb'            # collect_records
require 'lirias_pre_pnx/parsing_rules.rb'    # parse_record
require 'lirias_pre_pnx/writing_rules.rb'    # create_tar
############################################################### TEST ADAPTATIONS #####################################

begin
  collect_records()
end
