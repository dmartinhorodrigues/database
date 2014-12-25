# Create a mysql_service to test against
mysql_service 'default' do
  version node['mysql']['version']
  port '3306'
  initial_root_password 'ub3rs3kur3'
  action [:create, :start]
end

# Install the mysql2 gem into Chef's environment
mysql2_chef_gem 'default' do
  client_version node['mysql']['version']
  action :install
end

# Create a schema to test mysql_database :drop against
bash 'create datatrout' do
  code <<-EOF
  echo 'CREATE SCHEMA datatrout;' | /usr/bin/mysql -u root -h 127.0.0.1 -P 3306 -pub3rs3kur3;
  touch /tmp/troutmarker
  EOF
  not_if 'test -f /tmp/troutmarker'
  action :run
end

# Create a user to test mysql_database_user :drop against
bash 'create kermit' do
  code <<-EOF
  echo "CREATE USER 'kermit'@'localhost';" | /usr/bin/mysql -u root -h 127.0.0.1 -P 3306 -pub3rs3kur3;
  touch /tmp/kermitmarker
  EOF
  not_if 'test -f /tmp/kermitmarker'
  action :run
end

## Resources we're testing
mysql_database 'databass' do
  connection(
    host: '127.0.0.1',
    username: 'root',
    password: 'ub3rs3kur3'
    )
  action :create
end

mysql_database 'datatrout' do
  connection(
    host: '127.0.0.1',
    username: 'root',
    password: 'ub3rs3kur3'
    )
  action :drop
end

mysql_database_user 'piggy' do
  connection(
    host: '127.0.0.1',
    username: 'root',
    password: 'ub3rs3kur3'
    )
  action :create
end

mysql_database_user 'kermit' do
  connection(
    host: '127.0.0.1',
    username: 'root',
    password: 'ub3rs3kur3'
    )
  action :drop
end

mysql_database_user 'fozzie' do
  connection(
    host: '127.0.0.1',
    username: 'root',
    password: 'ub3rs3kur3'
    )
  database_name 'databass'
  password 'wokkawokka'
  host 'mars'
  privileges [:select, :update, :insert]
  require_ssl true
  action :grant
end
