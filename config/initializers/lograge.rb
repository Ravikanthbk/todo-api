Rails.application.configure do
  config.lograge.enabled = true
  config.lograge.custom_options = lambda do |event|
      { 
          time: event.time 
        }
  end
end

# config/initializers/lograge.rb
# Rails.application.configure do
#   config.lograge.base_controller_class = 'ActionController::API'
# end