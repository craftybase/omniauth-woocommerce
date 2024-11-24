# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "omniauth-woocommerce/version"

Gem::Specification.new do |gem|
  gem.name          = "omniauth-woocommerce"
  gem.version       = OmniAuth::WooCommerce::VERSION
  gem.authors       = ['Nathan Hawes']
  gem.email         = ['nath@craftybase.com']
  gem.summary       = %q{OmniAuth strategy for WooCommerce}
  gem.description   = %q{OmniAuth strategy for WooCommerce}

  gem.files         = Dir['lib/**/*.rb']
  gem.require_paths = ['lib']

  gem.add_runtime_dependency 'omniauth', '~> 2.1'
end
