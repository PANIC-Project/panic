# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
PanicWebapp::Application.initialize!

PanicWebapp::Application.configure do
  silence_warnings do
    begin
      require 'pry'
      IRB = Pry
    rescue LoadError
    end
  end
end
