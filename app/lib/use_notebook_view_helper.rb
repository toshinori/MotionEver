module UseNotebookViewHelper
  def refresh_all_notebooks &block
    return unless can_connect?

    unless EW.auth?
      EW.login_with_view_controller self,
        success: -> { log 'success'; refresh_all_notebooks &block },
        failure: method(:login_fail).to_proc
      return
    end

    success_proc = block.to_proc if block_given?
    success = -> notebooks do
      log 'success list notebooks'
      Notebook.refresh_all notebooks
      Notebook.save_and_load
      success_proc.call unless success_proc.nil?
    end

    failure = -> err do
      show_hud 'can not get notebooks.'
      log err
    end

    EW.list_notebooks_with_success success, failure:failure
  end
end
