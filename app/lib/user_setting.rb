class UserSetting

  class << self
    def instance
      Dispatch.once { @instance ||= UserSetting.new }
      @instance
    end
  end

  Settings = %w(
    select_tag_on_send_note select_notebook_on_send_note
  )

  Settings.each do |name|
    define_method("#{name}=") do |v|
      App::Persistence[name] = v
    end
    define_method("#{name}") do
      App::Persistence[name]
    end
  end
end
