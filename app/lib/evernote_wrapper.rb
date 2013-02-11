module EvernoteWrapper
  module_function

  def init_shared_host
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

  def login_with_view_controller(view, success:success, failure:failure)
    session.authenticateWithViewController(
      view,
      completionHandler: Proc.new do |err|
        if auth?
          success.call
        else
          failure.call
        end
      end
      )
  end

  def logout
    session.logout
  end

  def create_note(note_model)
    EDAMNote.alloc.init.tap do |n|
      # 改行コードを置換
      note_body = note_model.text.gsub(/\n/, '<br/>')
      # タイトルは必須、ないと保存できない
      # テキストの1行目をタイトルにする
      n.title = note_model.text.split(/\n/)[0]
      n.content = <<"EOS"
<?xml version='1.0' encoding='UTF-8' ?>
<!DOCTYPE en-note SYSTEM 'http://xml.evernote.com/pub/enml2.dtd'>
<en-note>
#{note_body}
</en-note>
EOS
      # tagは名前を配列で設定
      if note_model.tags
        n.tagNames = note_model.tags_for_edamnote
      end
      # notebookはguidを指定
      unless note_model.note_book.empty?
        p 'notebook'
        n.notebookGuid = note_model.note_book
      end
    end
  end

  # success、failureは成功時、失敗時に呼ばれるブロックで
  # それぞれ1つの引数を受け取る
  def send_note(note, success:success, failure:failure)
    store.createNote(
      note, success:success, failure:failure
      )
  end

  def list_tags_with_success(success, failure:failure)
    store.listTagsWithSuccess(
      success,
      failure: failure
      )
  end

  def list_notebooks_with_success(success, failure:failure)
    store.listNotebooksWithSuccess(
      success,
      failure:failure)
  end

  def create_tag_with_guid(guid, name:name, parentGuid:parent, updateSequenceNum:num)

    EDAMTag.alloc.initWithGuid(guid, name:name, parentGuid:parent, updateSequenceNum:num)
  end
end
::EW = EvernoteWrapper unless defined?(::EW)
