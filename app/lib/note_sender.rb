class NoteSender
  include Logger

  class << self
    def instance
      Dispatch.once { @instance ||= NoteSender.new }
      @instance
    end

    def queue_instance
      Dispatch.once { @queue ||= Dispatch::Queue.concurrent }
      @queue
    end
  end

  def running?
    not @queue.nil?
  end

  def can_start?

    log "running:#{running?}"
    log "auth?:#{EW.auth?}"
    log "Note not found:#{Note.find_by_status(Note::NotSaved).empty?}"
    log "reachable? :#{App.shared.delegate.reachable}"

    return false if running?
    return false unless App.shared.delegate.reachable?
    return false unless EW.auth?
    return false if Note.find_by_status(Note::NotSaved).empty?

    true
  end

  def start
    return unless can_start?

    log 'NoteSender.start'

    q = NoteSender.queue_instance
    g = Dispatch::Group.new

    #TODO Evernoteへの送信処理を追加する
    q.async(g) do
      Note.find_by_status(Note::NotSaved).each do |n|
        log 'found NotSaved notes'
        n.status = Note::Saved
        n.save
      end
      Note.save
      Note.load
    end

  end

end
