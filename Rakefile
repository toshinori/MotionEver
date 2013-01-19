# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'pit'
require 'bundler'
Bundler.require

Motion::Project::App.setup do |app|

  app.name = 'MotionEver'
  app.pods do
    pod 'Evernote-SDK-iOS'
    pod 'MBProgressHUD'
  end

  config = Pit.get("evernote.com", :require => {
    'host_name' => 'sandbox.evernote.com',
    'consumer_key' => 'key',
    'consumer_secret' => 'secret'
  })
  config.each_key {|k| ENV[k] ||= config[k]}

end
