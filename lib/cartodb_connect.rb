if FileTest.exists?('config/config.yml')
  puts "Using local config file"
  APP_CONFIG = YAML.load_file(Rails.root.join("config/config.yml"))
  CartoDB::Init.start(YAML.load_file(Rails.root.join('config/cartodb_config.yml')))
else
  puts "Trying to use heroku config vars"
  CartoDB::Init.start({:host => ENV['CARTODB_HOST'] , :oauth_key => ENV['CARTODB_KEY'], :oauth_secret => ENV['CARTODB_SECRET'], :username => ENV['CARTODB_USERNAME'], :password => ENV['CARTODB_PASSWORD'] })
end
