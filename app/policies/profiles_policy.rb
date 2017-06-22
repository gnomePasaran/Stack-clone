ProfilesPolicy = Struct.new(:user, :profiles) do
  def me?
    user.present?
  end

  def all?
    user.present?
  end
end
