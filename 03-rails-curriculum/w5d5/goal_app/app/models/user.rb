class User < ActiveRecord::Base
  include Commentable

  attr_reader :password

  after_initialize :ensure_session_token

  validates :username, :password_digest, :session_token, :presence => true
  validates :password, :length => { :minimum => 6 }, :on => :create

  has_many  :goals, :inverse_of => :user, :dependent => :destroy

  has_many :comments, dependent: :destroy, :as => :commentable

  has_many(
    :authored_comments,
    :primary_key => :id,
    :foreign_key => :user_id,
    :class_name => "Comment")


  def self.find_by_credentials(user_params)
    user = User.find_by_username(user_params[:username])

    if user && user.is_password?(user_params[:password])
      user
    else
      nil
    end
  end

  def self.generate_session_token
    SecureRandom::urlsafe_base64
  end

  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end

  def reset_session_token!
    self.session_token = self.class.generate_session_token
    self.save!

    self.session_token
  end

  def password=(pw)
    @password = pw
    self.password_digest = BCrypt::Password.create(pw)
  end

  def is_password?(pw)
    BCrypt::Password.new(self.password_digest).is_password?(pw)
  end

  def completed_goals
    self.goals.where(completed: true)
  end

  def open_goals
    self.goals.where(completed: false)
  end

end
