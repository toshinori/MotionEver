module Logger
  def log(message)
    if message.is_a? String
      NSLog(message)
    elsif message.is_a? NSError
      NSLog(message.localizedDescription)
    else
      NSLog(message.inspect)
    end
  end
end
