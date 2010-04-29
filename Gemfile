source 'http://rubygems.org'
ronin_ruby = 'git://github.com/ronin-ruby'
sophsec = 'git://github.com/sophsec'

group :runtime do
  gem 'bundler',	'~> 0.9.19'
  gem 'data_paths',	'~> 0.2.1'
  gem 'ffi-udis86',	'~> 0.1.0', :require => 'udis86'
  gem 'ruby-yasm',	'~> 0.1.1', :require => 'yasm'
  gem 'ronin-support',	'~> 0.1.0', :git => "#{ronin_ruby}/ronin-support.git"
  gem 'ronin-gen',	'~> 0.3.0', :git => "#{ronin_ruby}/ronin-gen.git"
  gem 'ronin',		'~> 0.4.0', :git => "#{ronin_ruby}/ronin.git"
end

group :development do
  gem 'rake',		'~> 0.8.7'
  gem 'jeweler',	'~> 1.4.0', :git => 'git://github.com/technicalpickles/jeweler.git'
  gem 'yard',		'~> 0.5.3'
end

gem 'rspec',	'~> 1.3.0', :group => [:development, :test]