require 'spec_helper'

module Vcloud
  describe MissingVappsForVdc do

    VDC_NAME = 'my vdc'

    context 'when VDC exists' do

      before(:each) {
        @query_runner = double(Vcloud::QueryRunner)
        allow(@query_runner).to receive(:run).with('orgVdc', anything) { [:vdc_stuff] }
      }

      it 'should return a list of vapps only present in the environment' do
        allow(@query_runner).to receive(:run).with('vApp', anything) {
          [{:name => 'that'}, {:name => 'this'}]
        }
        vapps_config = double(:vdc_vapps_config, :vapps => [{:name => 'this'}, {:name => 'the other'}])

        vapp_diff  = MissingVappsForVdc.new(VDC_NAME, @query_runner, vapps_config)
        vapp_names = vapp_diff.from_config

        vapp_names.should == ['that']
      end

      it 'should return a list of vapps only present in config' do
        allow(@query_runner).to receive(:run).with('vApp', anything) {
          [{:name => 'that'}, {:name => 'this'}]
        }
        vapps_config = double(:vdc_vapps_config, :vapps => [{:name => 'this'}, {:name => 'the other'}])

        vapp_diff  = MissingVappsForVdc.new(VDC_NAME, @query_runner, vapps_config)
        vapp_names = vapp_diff.from_environment

        vapp_names.should == ['the other']
      end

      it 'should handle no vapps in env' do
        allow(@query_runner).to receive(:run).with('vApp', anything) { [] }
        vapps_config = double(:vdc_vapps_config, :vapps => [{:name => 'this'}, {:name => 'the other'}])

        vapp_diff  = MissingVappsForVdc.new(VDC_NAME, @query_runner, vapps_config)
        vapp_names = vapp_diff.from_environment

        vapp_names.should == ['this', 'the other']
      end

      it 'should handle no vapps in config' do
        allow(@query_runner).to receive(:run).with('vApp', anything) { [{:name => 'that'}, {:name => 'this'}] }
        vapps_config = double(:vdc_vapps_config, :vapps => [])

        vapp_diff  = MissingVappsForVdc.new(VDC_NAME, @query_runner, vapps_config)
        vapp_names = vapp_diff.from_environment

        vapp_names.should == []
      end
    end

    context 'when VDC does NOT exist' do

      before(:each) {
        @query_runner = double(Vcloud::QueryRunner)
        allow(@query_runner).to receive(:run).with('orgVdc', anything) { [] }
      }

      it 'should raise an error when vdc does not exist in environment' do
        vapps_config = double(:vdc_vapps_config, :vapps => [])

        vapp_diff = MissingVappsForVdc.new(VDC_NAME, @query_runner, vapps_config)

        expect { vapp_diff.from_environment }.to raise_error(Vcloud::VdcNotFoundError)
      end
    end

  end

end
