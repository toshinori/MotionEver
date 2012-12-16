class UIView
  def x
    self.frame.origin.x
  end

  def x=(x)
    self.relocate(x, self.frame.origin.y)
  end

  alias_method :left, :x
  alias_method :left=, :x=

  def y
    self.frame.origin.y
  end

  def y=(y)
    self.relocate(self.frame.origin.x, y)
  end

  alias_method :top, :y
  alias_method :top=, :y=

  def relocate(x, y)
    self.frame = CGRectMake(x, y, self.frame.size.width, self.frame.size.height)
  end

  def relocate_by_offset(x, y)
    old_origin = self.frame.origin
    old_size = self.frame.size
    self.frame = CGRectMake(
      old_origin.x + x,
      old_origin.y + y,
      old_size.width,
      old_size.height)
  end

  def width
    self.frame.size.width
  end

  def width=(width)
    self.resize(width, self.frame.size.height)
  end

  def height
    self.frame.size.height
  end

  def height=(height)
    self.resize(self.frame.size.width, height)
  end

  def resize(width, height)
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, height)
  end

  def resize_by_offset(width, height)
    old_origin = self.frame.origin
    old_size = self.frame.size
    self.frame = CGRectMake(
      old_origin.x,
      old_origin.y,
      old_size.width + width,
      old_size.height + height)
  end

end
