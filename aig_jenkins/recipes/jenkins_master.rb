package 'jenkins' do
    source node['jenkins']['master']['url']
end

if node['platform_family'] == "debian"

template '/etc/default/jenkins' do
    source   'jenkins-config-debian.erb'
    mode     '0644'
    notifies :restart, 'service[jenkins]', :immediately
  end
elsif node['platform_family'] == "rhel"
  directory node['jenkins']['master']['home'] do
    owner     node['jenkins']['master']['user']
    group     node['jenkins']['master']['group']
    mode      '0755'
    recursive true
  end

  template '/etc/sysconfig/jenkins' do
    source   'jenkins-config-rhel.erb'
    mode     '0644'
    notifies :restart, 'service[jenkins]', :immediately
  end
end

service 'jenkins' do
  supports status: true, restart: true, reload: true
  action [:enable, :start]
end

remote_directory '/var/lib/jenkins/plugins' do
source 'plugins'
action :create
owner node['jenkins']['master']['user']
group node['jenkins']['master']['group']
mode '0755'
end

