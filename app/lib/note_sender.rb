class NoteSender
  include Logger

  attr_accessor :pause

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

    @pause = false

    log 'NoteSender.start'

    q = NoteSender.queue_instance
    g = Dispatch::Group.new

    q.async(g) do
      Note.find_by_status(Note::NotSaved).each do |n|

        break if @pause

        log 'found NotSaved notes'
        n.status = Note::Saving
        n.save
        Note.save_and_load

        en_note = EW.create_note(n)

        success = -> sent_note do
          NetworkActivityIndicator.off
          n.status = Note::Saved
          n.save
          Note.save_and_load
          log "note(id:#{n.id}) sent."
        end

        failure = -> err do
          NetworkActivityIndicator.off
          n.status = Note::NotSaved
          n.save
          Note.save_and_load
          log "can not send note #{err}."
        end

        NetworkActivityIndicator.on
        EW.send_note(en_note, success: success, failure: failure)

      end
    end

    stop
  end

  def stop
    @queue = nil
  end

end
