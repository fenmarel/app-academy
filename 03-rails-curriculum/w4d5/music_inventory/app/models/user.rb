class User < ActiveRecord::Base
  validates :username, :password_digest, :email, :presence => true
  validates :username, :email, :uniqueness => true
  validates :password, :length => { :minimum => 5, :allow_nil => true }
  before_validation :ensure_session_token

  attr_reader :password

  def self.generate_session_token
    SecureRandom.urlsafe_base64(16)
  end

  def self.find_by_credentials(user_params)
    user = User.find_by_username(user_params[:username])

    if user.is_password?(user_params[:password])
      user
    else
      nil
    end
  end

  def password=(pw)
    @password = pw
    self.password_digest = BCrypt::Password.create(@password)
  end

  def is_password?(pw)
    BCrypt::Password.new(self.password_digest).is_password?(pw)
  end

  def ensure_session_token
    self.session_token ||= User.generate_session_token
  end

  def reset_session_token!
    @user = self

    @user.session_token = User.generate_session_token
    @user.save!

    @user.session_token
  end
end