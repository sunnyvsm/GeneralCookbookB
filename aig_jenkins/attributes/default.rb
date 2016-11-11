if  node['platform_family'] == "rhel"
default['jenkins']['master']['version'] = 'jenkins-2.9-1.1.noarch.rpm'
default['jenkins']['master']['url'] = "/home/arpit/repos/#{node['jenkins']['master']['version']}"
elsif node['platform_family'] == "debian"
default['jenkins']['master']['version'] = 'jenkins_2.9_all.deb'
default['jenkins']['master']['url'] = "/home/arpit/repos/#{node['jenkins']['master']['version']}"
end

