class Object
  def in?(collection)
    collection.include?(self)
  end
  
  def try(meth, *args)
    self.send(meth, *args) if !self.nil?
  end
end
