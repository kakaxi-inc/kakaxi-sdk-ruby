class InvalidCredentials < StandardError
  def initialize(email, password, msg='email: %s, or password: %s is invalid')
    super(msg % [email, password])
  end
end

