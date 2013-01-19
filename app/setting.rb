class Setting
  class << self
    def evernote_host
      ENV['host_name']
    end

    def consumer_key
      ENV['consumer_key']
    end

    def consumer_secret
      ENV['consumer_secret']
    end

  end
end
