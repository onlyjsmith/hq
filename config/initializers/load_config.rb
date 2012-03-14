# TODO - Check if this works in production
APP_CONFIG = YAML.load_file(Rails.root.join("config/config.yml"))

CartoDB::Init.start(YAML.load_file(Rails.root.join('config/cartodb_config.yml')))