require File.join(File.dirname(__FILE__), "config/init.rb")

eval File.read(File.join(File.dirname(__FILE__), "lib/urack/middlewares.rb"))

run URack::App.new(:root_app => FrontController.action(:index), 
                   :not_found_app => ExceptionsController.action(:not_found))
