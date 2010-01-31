require ::File.join(::File.dirname(__FILE__), "vendor/gems/environment.rb")
require ::File.join(::File.dirname(__FILE__), "lib/urack/urack.rb")

URack.root = ::File.expand_path(::File.dirname(__FILE__))
URack::Bootloader.run(self.send(:binding))

run URack.router
