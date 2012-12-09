# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'bundler'
Bundler.require

Motion::Project::App.setup do |app|

  app.name = 'MotionEver'
  app.pods do
    pod 'Evernote-SDK-iOS'
  end

  app.vendor_project 'vendor/PXEngine.framework',
    :static,
    products: ['PXEngine'], :headers_dir => 'Headers'

  config_file = 'config.yml'
  if File.exist?(config_file)
    config = YAML::load_file(config_file)

    init_env = ->(key) {ENV[key] ||= config[key]}

    init_env.call('evernote_host')
    init_env.call('consumer_key')
    init_env.call('consumer_secret')

  end

end
