required_plugins = %w( vagrant-hostsupdater )
required_plugins.each do |plugin|
    exec "vagrant plugin install #{plugin};vagrant #{ARGV.join(" ")}" unless Vagrant.has_plugin? plugin || ARGV[0] == 'plugin'
end

Vagrant.configure("2") do |config|

  config.vm.define "app" do |app|
    app.vm.box = "ubuntu/xenial64"
    app.vm.network "private_network", ip: "192.168.10.100"
    app.hostsupdater.aliases = ["development.local"]
    
    # Synced app folder
    app.vm.synced_folder "app", "/app"
    app.vm.synced_folder "environment/app/templates", "/home/ubuntu/templates"
    app.vm.synced_folder "environment/app/profile.d", "/home/ubuntu/profile.d"

    # Provisioning
    app.vm.provision "shell", path: "environment/app/provision.sh"
  end

  config.vm.define "db" do |db|
    db.vm.box = "ubuntu/xenial64"
    db.vm.network "private_network", ip: "192.168.10.150"
    db.hostsupdater.aliases = ["database.local"]
    
    # Synced app folder
    db.vm.synced_folder "environment/db/templates", "/db/templates"
    db.vm.synced_folder "environment/db/profile.d", "/home/ubuntu/profile.d"

    # Provisioning
    db.vm.provision "shell", path: "environment/db/provision.sh"
  end
end