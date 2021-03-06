#
# Cookbook:: nginxserver
# Recipe:: default
include_recipe "firewall"

#Set up our web users and groups
user 'www-data' do
  action :create
  shell '/bin/false'
  system true
  end

group 'www-data' do
  action :create
end

group 'www-data' do
  action :modify
  members 'www-data'
  append true
end

#Fix our aptitude cache
apt_update 'Update the apt cache daily' do
  frequency 86_400
  action :periodic
end

# enable platform default firewall
firewall 'default' do
  action :install
end

#Allow world to port 22
firewall_rule 'nginx_22' do
  port  22
  source '0.0.0.0/0'
  protocol  :tcp
  command :allow
end
#Allow localhost to port 3400
firewall_rule 'nginx_3400' do
  port 3400
  source '127.0.0.1/24'
  direction :in
  protocol :tcp
  command :allow
end

#Allow world to port 3200
firewall_rule 'nginx_3200' do
  port  3200
  source '0.0.0.0/0'
  protocol  :tcp
  command :allow
end
#Allow localhost to port 3400
firewall_rule 'nginx_3400' do
  port 3400
  source '127.0.0.1/24'
  direction :in
  protocol :tcp
  command :allow
end
#Install NGINX and configure our sites
package 'nginx'

service 'nginx' do
  supports status: true
  action [:enable, :start]
end

file '/etc/nginx/sites-available/www.example.com' do
  content 'server {
          listen 3200;
          listen [::]:3200;

          location / {
              proxy_pass http://localhost:3400;
            }
          server_name www.example.com;
  }

  server {

          listen 3200 default_server;
          listen [::]:3200 default_server;

          error_page 404 /404.html;
          location = / {
                  return 404;
         }

          location = /404.html {
                  root /var/www/html;
          }
          server_name _;
  }'
  end

file '/etc/nginx/sites-available/localhost' do
content 'server {
    listen 3400;
    listen [::]:3400;
    root /var/www/html;
    # Add index.php to the list if you are using PHP
    index index.html;
    location / {
    try_files $uri $uri/ =404;
    }

    server_name localhost;
}'
end
#set up our  hosting files
directory '/var/www/' do
  owner 'www-data'
  group 'www-data'
  mode '0755'
  action :create
end

directory '/var/www/html' do
  owner 'www-data'
  group 'www-data'
  mode '0755'
  action :create
end
file '/var/www/html/404.html' do
content '<html>
  <h1> This is a custom 404 page. </h1>
</html>'
  owner 'www-data'
  group 'www-data'
  mode '0644'
  action :create
end
file '/var/www/html/index.html' do
content '<html>
  <h1> Welcome to www.example.com </h1>
</html>'
  owner 'www-data'
  group 'www-data'
  mode '0644'
  action :create
end
#Enable our sites in nginx
link '/etc/nginx/sites-enabled/www.example.com' do
  to '/etc/nginx/sites-available/www.example.com'
end
link '/etc/nginx/sites-enabled/localhost' do
  to '/etc/nginx/sites-available/localhost'
end

#Restart nginx
service "nginx" do
  action :Restart
end
