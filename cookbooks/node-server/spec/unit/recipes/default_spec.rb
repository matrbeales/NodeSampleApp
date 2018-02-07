#
# Cookbook:: node-server
# Spec:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'node-server::default' do
  context 'When all attributes are default, on an Ubuntu 16.04' do
    let(:chef_run) do
      # for a complete list of available platforms and versions see:
      # https://github.com/customink/fauxhai/blob/master/PLATFORMS.md
      runner = ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04')
      runner.converge(described_recipe)
    end

     it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

      it 'should include apt' do
      expect(chef_run).to include_recipe('apt')
    end

    it 'should install nodejs' do
      expect(chef_run).to include_recipe('nodejs')
    end

     it 'should install git' do
      expect(chef_run).to include_recipe('git::default')
    end


   

    it 'should install nginx' do
      expect(chef_run).to install_package 'nginx'
    end

    it 'enable the nginx service' do
      expect(chef_run).to enable_service 'nginx'
    end

    it 'start the nginx service' do
      expect(chef_run).to start_service 'nginx'
    end

    it 'should print "Test file is present"' do
      expect(chef_run).to create_template('/etc/nginx/sites-available/default')
    end

    it "update the name /etc/nginx/sites-available/default" do
      template = chef_run.template('/etc/nginx/sites-available/default')
      expect(template).to notify('service[nginx]').to(:reload)
   end

    # it 'should install nodejs::npm' do
    #   expect(chef_run).to include_recipe('nodejs::npm')
    # end

    it 'should a value for the magic_shell_environment' do
      expect(chef_run).to add_magic_shell_environment('MONGODB_URI')
    end

    it 'should install pm2 via npm' do
      expect(chef_run).to install_nodejs_npm('pm2')
    end

    it 'should install bower via npm' do
      expect(chef_run).to install_nodejs_npm('bower')
    end

 


  end
end
