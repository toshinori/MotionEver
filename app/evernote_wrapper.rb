module EvernoteWrapper
  module_function

  def init_shared_host
    EvernoteSession.setSharedSessionHost(
      Setting.evernote_host,
      consumerKey:Setting.consumer_key,
      consumerSecret:Setting.consumer_secret
      )
  end

end
::EW = EvernoteWrapper unless defined?(::EW)
