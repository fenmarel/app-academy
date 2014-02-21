class User < ActiveRecord::Base
  attr_reader :password

  validates :user_name, :password_digest, :presence => true
  validates :user_name, :uniqueness => true
  validates :password, :length => { :minimum => 3, :allow_nil => true }
  after_initialize :ensure_session_token

  has_many(
    :cats,
    :primary_key => :id,
    :foreign_key => :user_id,
    :class_name => 'Cat'
  )

  def self.find_by_credentials(params)
    user = User.find_by_user_name(params[:user_name])

    if user && user.is_password?(params[:password])
      user
    else
      nil
    end
  end

  def password=(pw)
    @password = pw
    self.password_digest = BCrypt::Password.create(pw)
  end

  def is_password?(pw)
    BCrypt::Password.new(self.password_digest).is_password?(pw)
  end

  def self.generate_session_token
    SecureRandom.urlsafe_base64(16)
  end

  def reset_session_token_for_device!(device)
    m = MultiSession.new(:user_id => self.id, :device => device[:device], ip_address: device[:ip_address])
    m.session_token = SecureRandom.urlsafe_base64(16)
    m.save!

    m.session_token
  end

  def ensure_session_token
    m = MultiSession.find_by_user_id(self.id) || MultiSession.new(:user_id => self.id)
    m.session_token ||= self.class.generate_session_token
  end
end