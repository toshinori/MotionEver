# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'pit'
require 'bundler'
Bundler.require

Motion::Project::App.setup do |app|

  app.name = 'MotionEver'
  app.deployment_target = '5.1'

  app.pods do
    pod 'Evernote-SDK-iOS'
    pod 'MBProgressHUD'
  end

  # pitを使ってEvernoteの設定を読み込む
  config = Pit.get("evernote.com", :require => {
    'host_name' => 'sandbox.evernote.com',
    'consumer_key' => 'key',
    'consumer_secret' => 'secret'
  })
  config.each_key {|k| ENV[k] ||= config[k]}

  # Pixateの設定を読み込む
  pixate_config = Pit.get('Pixate', require: {
    'user' => 'user',
    'key' => 'key',
    'framework' => 'framework'
  })
  pixate_config.each_key {|k| app.pixate.send("#{k}=", pixate_config[k])}

end
