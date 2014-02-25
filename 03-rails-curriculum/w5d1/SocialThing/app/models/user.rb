# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string(255)      not null
#  password_digest :string(255)      not null
#  session_token   :string(255)      not null
#  created_at      :datetime
#  updated_at      :datetime
#  reset_token     :string(255)
#

class User < ActiveRecord::Base
  attr_reader :password

  before_validation :ensure_session_token
  before_validation :ensure_password_reset_token
  validates :password_digest, :session_token, :reset_token, :presence => true
  validates :email, :presence => true, :uniqueness => true
  validates :password, :length => { :minimum => 5, :allow_nil => true }

  has_many :posts, :inverse_of => :author, :dependent => :destroy
  has_many :friend_circles, :dependent => :destroy

  def self.generate_session_token
    SecureRandom::urlsafe_base64(16)
  end

  def reset_session_token!
    self.session_token = self.class.generate_session_token
    self.save!
    self.session_token
  end

  def password=(plaintext)
    @password = plaintext
    self.password_digest = BCrypt::Password.create(plaintext)
  end

  def is_password?(plaintext)
    BCrypt::Password.new(self.password_digest).is_password?(plaintext)
  end

  def self.find_by_credentials(email, plaintext)
    user = User.find_by_email(email)
    return nil unless user
    user.is_password?(plaintext) ? user : nil
  end

  private

  def ensure_session_token
    self.session_token = self.class.generate_session_token
  end

  def ensure_password_reset_token
    self.reset_token = self.class.generate_session_token
  end
end
