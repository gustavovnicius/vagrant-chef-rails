set :stage, :production
set :ssh_options, {
  keys: ["PRIVATE_KEY_PATH"]
}
server 'SERVER_IP', user: 'ubuntu', roles: [:app, :web, :db], primary: true
