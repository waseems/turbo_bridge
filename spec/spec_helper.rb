require 'turbo_bridge'
require 'yaml'

# Need some auth credentials to run live integration tests
TurboBridge::Config.merge(YAML::load_file("test_config.yml"))

#TurboBridge::Api.configure_connection {|conn| conn.response :logger }