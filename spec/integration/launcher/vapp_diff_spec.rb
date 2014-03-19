require 'spec_helper'

describe Vcloud::VappDiff do

  context 'with minimum input setup' do

    it 'works as expected' do
      vdc_name = define_test_data[:vdc_name]
      vdc_config_dir = File.join(File.dirname(__FILE__), 'data/vapp_diff_vdc_config')

      missing_vapps = Vcloud::VappDiff.new.run(vdc_config_dir, vdc_name)

      missing_vapps[:missing_from_env].should == ['wibble-wobble_jonny_5']
      missing_vapps[:missing_from_files].should_not be_nil
    end

  end

  def define_test_data
    {
      vdc_name: ENV['VCLOUD_VDC_NAME'],
    }
  end

end
