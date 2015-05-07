class User

  def initialize
    @flag = nil
  end

  def admin_flag
    @flag = true
  end

  def user_flag
    @flag = false
  end

  def flag
    @flag
  end
end
