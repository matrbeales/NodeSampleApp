require 'serverspec'

# Required by serverspec
set :backend, :exec

describe package ('nginx') do
	it { should be_installed }
end

describe service ('nginx') do 
	it { should be_running }
	it { should be_enabled }
end

describe port(80) do
	it { should be_listening }
end

describe package ('nodejs') do
  it { should be_installed }
end

describe command ("node -v") do 
	its (:stdout) { should match /.6\.10\../ }
end

describe command ("git --version") do 
	its (:stdout) { should match /2\.7\.4/ }
end

describe command ("npm -v") do 
	its (:stdout) { should match /3\.10\../ }
end

describe package ("pm2") do 
	it { should be_installed.by('npm') }
end

describe package ("bower") do 
  it { should be_installed.by('npm') }
end

# chef exec kitchen test -d never

# chef exec kitchen verify






# https://packages.chef.io/files/stable/chefdk/1.3.43/ubuntu/16.04/chefdk_1.3.43-1_amd64.deb
# https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chefdk_0.9.0-1_amd64.deb