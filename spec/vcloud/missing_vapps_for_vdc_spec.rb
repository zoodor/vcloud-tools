require 'spec_helper'

module Vcloud
  describe MissingVappsForVdc do

    VDC_NAME = 'my vdc'

    it 'should return a list of vapps only present in the environment' do
      query_runner = double(:query_runner, :run => [{:name => 'that'}, {:name => 'this'}])
      vapps_config = double(:vdc_vapps_config, :vapps => [{:name => 'this'}, {:name => 'the other'}])

      vapp_diff = MissingVappsForVdc.new(VDC_NAME, query_runner, vapps_config)
      vapp_names = vapp_diff.from_config

      vapp_names.should == ['that']
    end

    it 'should return a list of vapps only present in config' do
      query_runner = double(:query_runner, :run => [{:name => 'that'}, {:name => 'this'}])
      vapps_config = double(:vdc_vapps_config, :vapps => [{:name => 'this'}, {:name => 'the other'}])


      vapp_diff = MissingVappsForVdc.new(VDC_NAME, query_runner, vapps_config)
      vapp_names = vapp_diff.from_environment

      vapp_names.should == ['the other']
    end

    it 'should handle no vapps in env' do
      query_runner = double(:query_runner, :run => [])
      vapps_config = double(:vdc_vapps_config, :vapps => [{:name => 'this'}, {:name => 'the other'}])

      vapp_diff = MissingVappsForVdc.new(VDC_NAME, query_runner, vapps_config)
      vapp_names = vapp_diff.from_environment

      vapp_names.should == ['this', 'the other']
    end

    it 'should handle no vapps in config' do
      query_runner = double(:query_runner, :run => [{:name => 'that'}, {:name => 'this'}])
      vapps_config = double(:vdc_vapps_config, :vapps => [])

      vapp_diff = MissingVappsForVdc.new(VDC_NAME, query_runner, vapps_config)
      vapp_names = vapp_diff.from_environment

      vapp_names.should == []
    end

  end

end
