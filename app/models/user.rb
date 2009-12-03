class User
  def self.authenticate(login, password)
    (login == "jola" && password == "misio") ? User.new : nil
  end

  def self.get(id)
    User.new
  end

  def id
    666
  end
  
  def name
    id.to_s
  end
end
