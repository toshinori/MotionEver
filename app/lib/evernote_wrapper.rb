module EvernoteWrapper
  include Logger

  module_function

  def init_shared_host
    p "Host:#{Setting.evernote_host}"
    p "ConsumerKey:#{Setting.consumer_key}"
    p "ConsumerSecret:#{Setting.consumer_secret}"
    EvernoteSession.setSharedSessionHost(
      Setting.evernote_host,
      consumerKey:Setting.consumer_key,
      consumerSecret:Setting.consumer_secret
      )
  end

  def session
    EvernoteSession.sharedSession
  end

  def store
    EvernoteNoteStore.noteStore
  end

  def auth?
    session.isAuthenticated
  end

  def login(view, completionHandler:handler)
    session.authenticateWithViewController(
      view,
      completionHandler:handler
      )
  end

  def login_unless_auth(view, completionHandler:handler)
    return if auth?
    login(view, completion_handler)
  end

  def logout
    session.logout
  end

  def list_tags_with_success(success, failure:failure)
    store.listTagsWithSuccess(
      success,
      failure: failure
      )
  end

end
::EW = EvernoteWrapper unless defined?(::EW)
