class NoteSender
  include Logger

  def self.instance
    Dispatch.once { @instance ||= NoteSender.new }
    @instance
  end

  def self.queue_instance
    Dispatch.once { @queue ||= Dispatch::Queue.concurrent }
    @queue
  end

  def running?
    not @queue.nil?
  end

  def can_start?

    log "running:#{running?}"
    log "auth:#{EW.auth?}"
    log "Note.empty:#{Note.find(status: Note::StatusNotSaved).empty?}"
    log "reachable:#{App.shared.delegate.reachable}"

    return false if running?
    return false unless App.shared.delegate.reachable?
    return false unless EW.auth?
    return false if Note.find(status: Note::StatusNotSaved).empty?

    true
  end

  def start
    return unless can_start?

    q = NoteSender.queue_instance
    g = Dispatch::Group.new

    q.async(g) do
      Note.find_by_status(Note::NotSaved).each do |n|
        n.status = Note::Saved
        n.save
      end
      Note.save
      Note.load
    end

  end

end
