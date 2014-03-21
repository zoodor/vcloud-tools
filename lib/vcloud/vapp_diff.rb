require 'vcloud'

module Vcloud
  class VappDiff

    def run(vdc_config_dir, vdc_name, cli_options = {})
      vapp_config = Vcloud::VappConfig.new(vdc_config_dir)
      missing_vapps = Vcloud::MissingVappsForVdc.new(vdc_name, Vcloud::QueryRunner.new, vapp_config)
      result = {
          :missing_from_env => missing_vapps.from_environment,
          :missing_from_files => missing_vapps.from_config
      }
      cli_options[:yaml] ? print(result.to_yaml) : print(JSON.pretty_generate result)
    end
    
  end
end
