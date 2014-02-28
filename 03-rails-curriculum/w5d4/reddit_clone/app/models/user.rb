class User < ActiveRecord::Base
  attr_reader :password

  before_validation :ensure_session_token

  validates :username, :presence => true
  validates :password, :length => {:minimum => 6, :allow_nil => true}

  has_many :subs
  has_many :links
  has_many :comments
  has_many :user_votes


  def self.find_by_credentials(user_params)
    @user = User.find_by_username(user_params[:username])

    @user && @user.is_password?(user_params[:password]) ? @user : nil
  end

  def self.generate_token
    SecureRandom::urlsafe_base64
  end

  def password=(pw)
    @password = pw
    self.password_digest = BCrypt::Password.create(pw)
  end

  def is_password?(pw)
    BCrypt::Password.new(self.password_digest).is_password?(pw)
  end

  def is_moderator_of(sub)
    sub.moderator == self
  end

  def ensure_session_token
    self.session_token ||= self.class.generate_token
  end

  def reset_session_token!
    self.session_token = self.class.generate_token
    self.save

    self.session_token
  end
end
